class AddArchivedStatus < ActiveRecord::Migration
  #empty classes to avoid validations/hooks
  class Status < ActiveRecord::Base
  end
  class ReservationNotice < ActiveRecord::Base
  end

  # NOTE: Altered from additional migration - it used to raise unless
  #       STATUSES included Archived, but this broke migration
  def up
    STATUSES.push('Archived') unless STATUSES.include?('Archived')
    Rake::Task['inscriptio:bootstrap:default_statuses'].invoke
    ReservableAssetType.all.each do |rat|
      ReservationNotice.create(:library_id => rat.library.id,
                               :reservable_asset_type_id => rat.id,
                               :status_id => Status.find_by_name('Archived').id,
                               :subject => 'Archived',
                               :message => 'Archived')
    end
  end

  def down
    archived_id = Status.find_by_name('Archived').id

    ReservationNotice.destroy_all(:status_id => archived_id)

    Reservation.where(:status_id => archived_id).each do |res|
      res.status = Status.find_by_name('Expired')
      res.save!
    end
    adapter_type = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    case adapter_type
    when :mysql, :mysql2
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE statuses')
    when :sqlite
      Status.destroy_all
      ActiveRecord::Base.connection.execute("DELETE FROM statuses;DELETE FROM sqlite_sequence WHERE name = 'statuses';")
    when :postgresql
      Status.destroy_all
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE statuses_id_seq RESTART WITH 1")
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
    end

    STATUSES.reject{|el| el == 'Archived'}.each do |s|
      status = Status.new(:name => s)
      status.save
      puts "Successfully created #{status.name}!"
    end
  end
end
