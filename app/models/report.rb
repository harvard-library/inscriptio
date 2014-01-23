class Report
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def self.active_carrels (start_horizon = nil, end_horizon = nil)
    # Only bound search if args exist and are datey
    start_end_clause = ''
    if start_horizon.is_a? Date
      start_end_clause += "AND end_date > '#{start_horizon.to_s}'"
    end
    if end_horizon.is_a? Date
      start_end_clause += "AND start_date < '#{end_horizon.to_s}'"
    end

    results = ActiveRecord::Base.connection.query(<<-SQL)
     SELECT l.name AS l_name,
       rat.name AS rat_name,
       COUNT(ra.id) AS num_ras
     FROM libraries l
     JOIN  reservable_asset_types rat
       ON l.id = rat.library_id
     JOIN reservable_assets ra
       ON rat.id = ra.reservable_asset_type_id
     JOIN (SELECT reservable_assets.id,
                  count(reservations.id) AS num_res
           FROM reservable_assets, reservations, statuses
           WHERE reservable_assets.id = reservations.reservable_asset_id
             AND reservations.deleted_at IS NULL
             AND reservations.status_id = statuses.id
             AND statuses.name IN ('Pending', 'Approved')
             #{start_end_clause}
           GROUP BY reservable_assets.id) r
       ON ra.id = r.id WHERE num_res > 0
     GROUP BY l_name, rat_name
    SQL

    results.unshift %w(library_name, rat_name, active_carrels)
  end

end
