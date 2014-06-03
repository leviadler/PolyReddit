module ApplicationHelper

  def render_errors
    flash[:errors] if flash[:errors]
  end
  
  def auth_token_input
    <<-HTML.html_safe
      <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    HTML
  end
end
