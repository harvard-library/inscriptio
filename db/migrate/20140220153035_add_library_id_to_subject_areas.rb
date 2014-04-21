class AddLibraryIdToSubjectAreas < ActiveRecord::Migration
  class SubjectArea < ActiveRecord::Base
    # empty class to avoid validation
  end

  class CallNumber < ActiveRecord::Base
    # empty class to avoid validation
  end

  def up
    add_column :subject_areas, :library_id, :integer # first step!
    SubjectArea.reset_column_information

    # Map of which floors belong to which libraries
    # Note: Deliberately left a string because it's being fed directly to an IN clause in a query
    floor_map = query(<<-SQL).map {|pair| [pair.first.to_i, pair.last]}.to_h
      SELECT libraries.id, string_agg(floors.id::text, ',')
        FROM libraries
        LEFT OUTER JOIN floors
          ON libraries.id = floors.library_id
      GROUP BY libraries.id
    SQL

   # All subject area ids, with attendant libraries
    result = query(<<-SQL)
      SELECT sa.id,
             string_agg(DISTINCT l.id::text, ',') libraries
        FROM subject_areas sa
        LEFT OUTER JOIN floors_subject_areas fsa
          ON sa.id = fsa.subject_area_id
        LEFT OUTER JOIN floors f
          ON fsa.floor_id = f.id
        LEFT OUTER JOIN libraries l
          ON f.library_id = l.id
      GROUP BY sa.id;
    SQL

    # Hashify the resulting mess, splitting aggregates and replacing nils with empty arrays
    # Result: hash[subject_area_id] = [array,of,library_ids]
    sa_map = result.reduce({}) do |result, subject_area|
      sa_id = subject_area.first.to_i

      libs = subject_area.last ? subject_area.last.split(',').map(&:to_i).sort : []

      result[sa_id] = libs
      result
    end

    sa_map.each do |(sa_id, libs)|
      if libs.empty?
        # If it doesn't have a library, there'll need to be a copy for all libraries
        libs = Library.pluck(:id).sort
      end

      # Update the existing record with first (possibly only) library
      execute(<<-SQL)
        UPDATE subject_areas sa SET library_id = #{libs.first} WHERE sa.id = #{sa_id}
      SQL
      rest = libs.drop(1)

      # For each remaining library, copy call_numbers and split floors out by library

      # If there aren't more libraries, we're done here
      unless rest.empty?
        old_sa = SubjectArea.find(sa_id)

        # get call numbers associated with original subject area
        old_call_nums = CallNumber.find(query("SELECT id FROM call_numbers WHERE subject_area_id = #{old_sa.id}"))
        new_sa_ids = []
        rest.each do |l_id|
          new_sa = SubjectArea.create(old_sa.attributes.except("id", "created_at", "updated_at", "library_id").merge("library_id" => l_id))
          new_sa_ids.push new_sa.id
          # if this library has floors, assign floors for this library to new subject area
          execute(<<-SQL) if floor_map[l_id]
            UPDATE floors_subject_areas SET subject_area_id = #{new_sa.id} WHERE subject_area_id = #{old_sa.id} AND floor_id IN (#{floor_map[l_id]})
          SQL
        end # rest.each

        SubjectArea.clear_cache!

        old_call_nums.each do |old_cn|
          rest.each do |l_id|
            # create a new call number
            new_cn = CallNumber.create(old_cn.attributes.except("id",
                                                                "created_at",
                                                                "updated_at",
                                                                "subject_area_id").merge("subject_area_id" => SubjectArea.where(:library_id => l_id,
                                                                                                                                :id => new_sa_ids)[0].id))
            # if this library has floors, assign floors for this library to new call number
            execute(<<-SQL) if floor_map[l_id]
              UPDATE call_numbers_floors SET call_number_id = #{new_cn.id} WHERE call_number_id = #{old_cn.id} AND floor_id IN (#{floor_map[l_id]})
            SQL
          end # rest.each
        end #old_call_nums.each
      end # unless rest.empty?
    end # sa_map.each
    execute <<-SQL
      ALTER TABLE subject_areas
        ALTER COLUMN library_id SET NOT NULL,
        ADD CONSTRAINT fk_subject_areas_libraries
        FOREIGN KEY (library_id)
        REFERENCES libraries(id)
    SQL

  end

  def down
    # returns a pair of comma separated strings: [SA_IDS_TO_MERGE, FLOOR_IDS]
    result = query(<<-SQL)
      SELECT string_agg(DISTINCT sa.id::text, ',') ids,
             string_agg(DISTINCT f.id::text, ',') as floor_ids
        FROM subject_areas sa
        LEFT OUTER JOIN floors_subject_areas fsa
          ON sa.id = fsa.subject_area_id
        LEFT OUTER JOIN floors f
          ON f.id = fsa.floor_id
      GROUP BY sa.name, sa.long_name, sa.description
    SQL

    # hashify query, resulting structure is:
    # {
    #   103 => # lowest ordered ID
    #     { :dup_sa_ids => [42, 2001], # IDs of Subject Areas that duplicate content of lowest
    #       :floor_ids => [3,5,7]}, # IDs of floors attached to any of the subject areas
    #   104 => # etc.
    # }
    sa_ids_map = result.reduce({}) do |result, pair|
      ids_to_merge = pair.first.split(',').map(&:to_i).sort
      result[ids_to_merge.first] = {:dup_sa_ids => ids_to_merge.drop(1), :floor_ids => pair.last ? pair.last.split(',').map(&:to_i) : []}
      result
    end

    sa_ids_map.each do |orig_id, v|
      unless v[:dup_sa_ids].empty?
        orig_call_numbers = CallNumber.where(:subject_area_id => orig_id)

        orig_call_numbers.each do |old_cn|
          dup_ids = CallNumber.where("id <> #{old_cn.id} AND subject_area_id IN (#{v[:dup_sa_ids].join(',')})").where(old_cn.attributes.except('id', 'subject_area_id', 'created_at','updated_at')).pluck(:id).join(',')
          unless dup_ids.blank?
            execute "UPDATE call_numbers_floors SET call_number_id = #{old_cn.id} WHERE call_number_id IN (#{dup_ids})"
            execute "DELETE FROM call_numbers WHERE id IN (#{dup_ids})"
          end
        end
        execute "UPDATE floors_subject_areas SET subject_area_id = #{orig_id} WHERE subject_area_id IN (#{v[:dup_sa_ids].join(',')})"
        execute "DELETE FROM subject_areas WHERE id IN (#{v[:dup_sa_ids].join(',')})"
      end
    end

    execute <<-SQL
      ALTER TABLE subject_areas
      DROP CONSTRAINT fk_subject_areas_libraries
    SQL
    remove_column :subject_areas, :library_id # last step!
  end
end
