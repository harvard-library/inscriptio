module ApplicationHelper
  
  def display_message(message_key = :default)
    begin
      Message.find_by_description(message_key.to_s)
    rescue
      "Couldn't find that message."
    end
  end
end
