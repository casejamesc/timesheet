json.array!(@shifts) do |shift|
  json.extract! shift, :id, :time_in, :time_out, :user_id, :project_id, :task_id, :notes, :add_cost
  json.url shift_url(shift, format: :json)
end
