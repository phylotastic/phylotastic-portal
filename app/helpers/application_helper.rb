module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Phylotastic Portal"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  def active?(link_path)
    current_page?(link_path) ? "active" : ""
  end
  
  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: "panel panel-danger", id: "error_explanation") do
        concat(content_tag(:div, class: "panel-heading") do
          concat(content_tag(:h4, class: "panel-title") do
            concat "The form contains #{pluralize(object.errors.count, "error")}:"
          end)
        end)
        concat(content_tag(:div, class: "panel-body") do
          concat(content_tag(:ul) do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end
  
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if cookies.signed[:guest_user_email]
        logging_in
        guest_user.delete
        cookies.delete :guest_user_email
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||=
      User.find_by!(email: (cookies.permanent.signed[:guest_user_email] ||= create_guest_user.email))

  # if cookies.signed[:guest_user_email] invalid
  rescue ActiveRecord::RecordNotFound #
    cookies.delete :guest_user_email
    guest_user
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # put all your processing for transferring
    # from a guest user to a registered user
    # i.e. update votes, update comments, etc.
    guest_user.text_entries.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.links.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.documents.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.dcas.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.onpls.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.cns.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.taxonomies.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
    guest_user.trees.each do |d|
      d.update_attributes(user_id: current_user.id)
    end
  end

  # creates guest user by adding a record to the DB
  # with a guest name and email
  def create_guest_user
    email_prov = ["example.com", "goo.com", "yah.com", "xfi.com", "nau.com", "pri.com", "ste.com", "wal.com", "bre.com", "pho.com"]
    u = User.create(:email => "guest_#{Time.now.to_i}#{rand(9999)}@#{email_prov.sample}")
    # u.skip_confirmation!
    u.save!(:validate => false)
    u
  end
end
