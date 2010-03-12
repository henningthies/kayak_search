# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def periodically_call_remote(options = {})
    variable = options[:variable] ||= 'poller'
    frequency = options[:frequency] ||= 10
    code = "#{variable} = new PeriodicalExecuter(function() 
{#{remote_function(options)}}, #{frequency})"
    javascript_tag(code)
  end
end
