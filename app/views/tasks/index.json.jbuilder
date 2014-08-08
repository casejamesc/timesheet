json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :status, :rate, :default, :user_id, :project_id
  json.url task_url(task, format: :json)
end
