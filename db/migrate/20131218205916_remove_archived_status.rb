class RemoveArchivedStatus < ActiveRecord::Migration
  #empty classes to avoid validations/hooks
  class Status < ActiveRecord::Base
  end
  class ReservationNotice < ActiveRecord::Base
  end

  def up
    archived_id = Status.find_by_name('Archived').id
    expired_id = Status.find_by_name('Expired').id
    ActiveRecord::Base.connection.execute("UPDATE reservations SET status_id = #{expired_id} WHERE status_id = #{archived_id}")
    ReservationNotice.destroy_all(:status_id => archived_id)
    Status.destroy_all
    if not STATUSES.include? 'Archived'
      Rake::Task['inscriptio:bootstrap:default_statuses'].invoke
    else
      STATUSES.reject{|el| el == 'Archived'}.each do |s|
        status = Status.new(:name => s)
        status.save
      end
    end
  end

  def down
    if STATUSES.include? 'Archived'
      Rake::Task['inscriptio:bootstrap:default_statuses'].invoke
      ReservableAssetType.all.each do |rat|
        ReservationNotice.create(:library_id => rat.library.id,
                                 :reservable_asset_type_id => rat.id,
                                 :status_id => Status.find_by_name('Archived').id,
                                 :subject => 'Archived',
                                 :message => 'Archived')
      end
    else
      raise "Needs 'Archived' status in config/initializers/00_inscriptio_init.rb'"
    end
  end
end
