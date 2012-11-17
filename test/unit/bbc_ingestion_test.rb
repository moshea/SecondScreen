require_relative '../test_helper'

class BBCIngestionTest < ActiveSupport::TestCase
  test "ingest_schedule should only ingest shows starting on a specified date" do
    schedule = File.open(File.dirname(__FILE__) + "/../fixtures/bbc-schedule.xml", 'r').read
    Channel.expects(:find).returns(FactoryGirl.create(:channel))
    BBCIngestion.any_instance.stubs(:open).yields(schedule)
    
    ingestor = BBCIngestion.new()
    ingestor.perform(1, '2012-10-10')
    
    broadcasts = Broadcast.all
    broadcasts.each do |broadcast|
      assert broadcast.start >= DateTime.strptime('2012-10-10 00:00:00', "%Y-%m-%d %H:%M:%S")
      assert broadcast.end <= DateTime.strptime('2012-10-10 23:59:59', "%Y-%m-%d %H:%M:%S")
    end
  end
end