class Activity
  include ActiveModel::Model

  def self.make_request(user, date_time = DateTime.now)
    date = date_time.strftime("%Y-%m-%d")
    params = {
      "request" => {
      "uid" => user.uid,
      "secret" => user.secret,
      "token" => user.token,
      "date" => date
    }}.to_query
    connection = Faraday.new
    response = connection.get "#{fitbit_service_uri}/api/v1/activity?#{params}"
    data = JSON.parse(response.body)
    stat = user.stats.find_or_create_by(date: date)
    stat.update(steps: data["steps_on_date"], sleep: data["sleep_on_date"])
    stat
  end

  def self.fitbit_service_uri
    if Rails.env == "production"
      "http://fitbit-service.herokuapp.com"
    else
      "http://localhost:9292"
    end
  end

end
