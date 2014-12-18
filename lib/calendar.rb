module Calendar
  def initialize_client(user)
    @client = Google::APIClient.new( {:application_name => "calendar", :application_version => "1.0"} )
    @client.authorization.access_token = user.oauth_token
    @client.authorization.refresh_token = user.refresh_token
    @client.authorization.client_id = AppConfig.google_client_id
    @client.authorization.client_secret = AppConfig.google_secret
    @service = @client.discovered_api('calendar', 'v3')
  end

  def import_vacation(vacation)
    initialize_client(vacation.user)
    page_token = nil
    result = @client.execute(api_method: @service.events.list,
      parameters: { 'calendarId' => AppConfig.calendar_id })

    while true
      events = result.data.items
      events.each do |e|
        usr = User.find_by(email: e.creator.email)
        if (e.summary =~ /#{AppConfig.calendar_summary_regex}/i) && (e.start.date.to_date >= 2.weeks.ago.to_date)
          imported = usr.vacations.build
          imported.starts_at = e.start.date
          imported.ends_at = e.end.date.to_date - 1.day
          imported.eventid = e.id
          imported.save
        end
      end
      if !(page_token = result.data.next_page_token)
        break
      end
      result = @client.execute(api_method: @service.events.list,
        parameters: { 'calendarId' => AppConfig.calendar_id, 'pageToken' => page_token })
    end
  end

  def export_vacation(vacation)
    event = {
      'summary' => "#{vacation.user.first_name} #{vacation.user.last_name} - vacation",
      'start' => { 'date' => vacation.starts_at },
      'end' => { 'date' => vacation.ends_at + 1.day }
    }

    initialize_client(user)
    result = @client.execute(
      :api_method => @service.events.insert,
      :parameters => { 'calendarId' => AppConfig.calendar_id},
      :body => JSON.dump(event),
      :headers => { 'Content-Type' => 'application/json' })

    vacation.update_attributes(eventid: result.data.id)
    vacation.save
  end

  def update_vacation(vacation)
    initialize_client(vacation.user)
    result = @client.execute(
      :api_method => @service.events.get,
      :parameters => { 'calendarId' => AppConfig.calendar_id, 'eventId' => vacation.eventid })

    event = result.data
    event.start.date = "#{vacation.starts_at}"
    event.end.date = "#{vacation.ends_at+1.day}"
    result = @client.execute(
      :api_method => @service.events.update,
      :parameters => { 'calendarId' => AppConfig.calendar_id, 'eventId' => vacation.eventid },
      :body => JSON.dump(event),
      :headers => { 'Content-Type' => 'application/json' })
  end

  def delete_vacation(vacation)
    initialize_client(vacation.user)
    result = @client.execute(api_method: @service.events.delete,
      parameters: { 'calendarId' => AppConfig.calendar_id, 'eventId' => vacation.eventid })
  end
end
