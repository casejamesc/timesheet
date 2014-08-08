json.array!(@projects) do |project|
  json.extract! project, :id, :name, :status, :rate, :default, :user_id
  json.url project_url(project, format: :json)
end
