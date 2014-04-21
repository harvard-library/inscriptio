class DropFloorsSubjectAreas < ActiveRecord::Migration
  def up
    # Check if there is data in floors_subject_areas that is not represented by call_number mapping
    endangered_records = query(<<-SQL)
      SELECT  fsa.subject_area_id, fsa.floor_id
        FROM (SELECT DISTINCT * FROM floors_subject_areas) fsa
                FULL JOIN (SELECT DISTINCT sa.id as subject_area_id,
                                  f.id as floor_id
                             FROM subject_areas sa
                             JOIN call_numbers cn
                               ON sa.id = cn.subject_area_id
                             JOIN call_numbers_floors cnf
                               ON cnf.call_number_id = cn.id
                             JOIN floors f
                               ON cnf.floor_id = f.id) sa_cn
                  ON fsa.floor_id = sa_cn.floor_id
                 AND fsa.subject_area_id = sa_cn.subject_area_id
               WHERE sa_cn.floor_id IS NULL OR sa_cn.subject_area_id IS NULL
               ORDER BY fsa.subject_area_id, fsa.floor_id
    SQL

    if endangered_records.count > 0
      record_display = ''
      endangered_records.each do |sa_id, f_id|
        sa = SubjectArea.find(sa_id)
        f = Floor.find(f_id)
        record_display << "\t#{sa.id}:#{sa.name} -> #{f.id}:#{f.name}\n"
      end

      # The first rule of responsibility club is We don't destroy data.
      # The second rule of responsibility club is WE DON'T DESTROY DATA
      raise ActiveRecord::ActiveRecordError.new(<<-ERR_TEXT)
        BAD DATA: There are records in floors_subject_areas that are not represented by mapping
         subject_areas->floors through call numbers.  Please inform the inscriptio Admin.

         Here is a listing of the relationships that would be lost:
         #{record_display}
      ERR_TEXT

    end # if endangered_rec...

    drop_table :floors_subject_areas
  end

  def down
    execute(<<-SQL)
      CREATE TABLE floors_subject_areas AS
         (SELECT sa.id as subject_area_id,
                 f.id as floor_id
            FROM subject_areas sa
            JOIN call_numbers cn
              ON sa.id = cn.subject_area_id
            JOIN call_numbers_floors cnf
              ON cnf.call_number_id = cn.id
            JOIN floors f
              ON cnf.floor_id = f.id
          GROUP BY sa.id, f.id
          ORDER BY sa.id, f.id)
      WITH DATA
    SQL
    add_index :floors_subject_areas, "floor_id"
    add_index :floors_subject_areas, "subject_area_id"
  end
end
