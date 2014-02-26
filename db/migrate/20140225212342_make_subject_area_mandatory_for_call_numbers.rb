class MakeSubjectAreaMandatoryForCallNumbers < ActiveRecord::Migration
  class CallNumber < ActiveRecord::Base
    # empty class to avoid validation
  end

  def up
    # Find call_numbers with either more or less libraries
    #  (through floors) than they should have
    cn_with_libs = query(<<-SQL).to_h
      SELECT id, libs
        FROM (SELECT cn.id, COUNT(DISTINCT l.id) libs
                FROM call_numbers cn
                LEFT OUTER JOIN call_numbers_floors cnf
                  ON cnf.call_number_id = cn.id
                LEFT OUTER JOIN floors f
                  ON cnf.floor_id = f.id
                LEFT OUTER JOIN libraries l
                  ON l.id = f.library_id
               GROUP BY cn.id) t
       WHERE libs <> 1
    SQL

    # If any of these has more than one library, bad data
    too_many_libs = cn_with_libs.select {|k,v| v.to_i != 0}
    if not too_many_libs.empty?
      raise ActiveRecord::ActiveRecordError.new(<<-ERR_TEXT)
        BAD DATA: There are one or more call numbers attached to floors in more than one library.

        The affected call numbers have ids: #{too_many_libs.keys.map(&:to_i).to_s}

      ERR_TEXT
    end
    # Get an array of call number ids with their libraries, through floors and subject areas respectively
    # Structure: array[cn_id, l_id_according_to_floors, l_id_according_to_subject_area]
    cn_libs_mapping = query(<<-SQL).sort {|a,b| a.first.to_i <=> b.first.to_i}
      SELECT DISTINCT cn.id,
                      f.library_id AS f_l,
                      sa.library_id AS sa_l
        FROM call_numbers cn
        LEFT OUTER JOIN call_numbers_floors cnf
          ON cn.id = cnf.call_number_id
        LEFT OUTER JOIN floors f
          ON f.id = cnf.floor_id
        LEFT OUTER JOIN subject_areas sa
          ON cn.subject_area_id = sa.id
    SQL

    # If a CN doesn't have a subject area with a library,
    #  or its subject area and its floor disagree on its library,
    #  bad data
    wrong_libs = cn_libs_mapping.select {|cn_id, f_lib, sa_lib| sa_lib.nil? or (f_lib and sa_lib != f_lib) }
    if not wrong_libs.empty?
      raise ActiveRecord::ActiveRecordError.new(<<-ERR_TEXT)
        BAD DATA: There are one or more call numbers with no subject_area,
          or with different libraries according to their floors and their subject areas.

        The affected call numbers have ids: #{wrong_libs.map(&:first).map(&:to_i).to_s}

      ERR_TEXT
    end

    execute(<<-SQL)
      ALTER TABLE call_numbers
        ALTER COLUMN subject_area_id SET NOT NULL,
        ADD CONSTRAINT fk_call_numbers_subject_area
        FOREIGN KEY (subject_area_id)
        REFERENCES subject_areas(id)
    SQL
  end

  def down
    execute(<<-SQL)
      ALTER TABLE call_numbers
        ALTER COLUMN subject_area_id DROP NOT NULL,
        DROP CONSTRAINT fk_call_numbers_subject_area
    SQL
  end
end
