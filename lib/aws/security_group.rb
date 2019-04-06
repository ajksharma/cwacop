require_relative '../resource'

class SecurityGroup < Resource

  def initialize(security_group)
    @security_group = security_group
  end

  def group_id
    @security_group.group_id
  end

  def group_name
    @security_group.group_name
  end

  def facts
    [
      [:typed_value, type_name, group_id],
      [:link, group_id, :name, group_name],
    ] + permission_facts
  end

  def permission_facts
    @security_group.ip_permissions.flat_map do |ip_permission|
      ip_permission.user_id_group_pairs.map do |group_pair|
        [:link, group_id, :group, group_pair.group_id]
      end
    end
  end

end