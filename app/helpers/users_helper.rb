module UsersHelper
  def active_if_exist(object)
    object ? 'active' : ''
  end
end
