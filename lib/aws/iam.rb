require_relative '../resource'

class IAM < Resource

  def initialize(iam_details)
    @iam_details = iam_details
  end

  def facts
    user_detail_facts + group_detail_facts + role_detail_facts + policy_facts
  end

  def policy_facts
    @iam_details.policies.flat_map do |policy|
      [
        [:typed_value, type_name, policy_id = policy.policy_id],
        [:link, policy_id, :name, policy.policy_name],
        [:link, policy_id, :arn, policy.arn]
      ]
    end
  end

  def role_detail_facts
    @iam_details.role_detail_list.flat_map do |role_detail|
      [
        [:typed_value, type_name, role_id = role_detail.role_id],
        [:link, role_id, :name, role_detail.role_name],
        [:link, role_id, :arn, role_detail.arn]
      ] + role_detail.role_policy_list.flat_map do |policy|
        binding.pry
      end + role_detail.instance_profile_list.flat_map do |instance_profile|
        [
          [:link, role_id, :instance_profile, instance_profile.instance_profile_id]
        ]
      end + role_detail.attached_managed_policies.flat_map do |attached_policy|
        [
          [:link, role_id, :attached_policy, attached_policy.policy_arn]
        ]
      end + role_detail.tags.flat_map do |tag|
        binding.pry
      end
    end
  end

  def group_detail_facts
    @iam_details.group_detail_list.flat_map do |group_detail|
      [
        [:typed_value, type_name, group_id = group_detail.group_id],
        [:link, group_id, :name, group_detail.group_name],
        [:link, group_id, :arn, group_detail.arn]
      ] + group_detail.group_policy_list.flat_map do |policy|
        binding.pry
      end + group_detail.attached_managed_policies.flat_map do |attached_policy|
        [
          [:link, group_id, :attached_policy, attached_policy.policy_arn]
        ]
      end
    end
  end

  def user_detail_facts
    # Grab all the unique identifiers and give them types and then link them up
    # to the user ID
    @iam_details.user_detail_list.flat_map do |user_detail| # Grab the unique identifiers and link them
      [
        [:typed_value, type_name, user_id = user_detail.user_id],
        [:link, user_id, :name, user_name = user_detail.user_name],
        [:link, user_id, :arn, arn = user_detail.arn],
      ] + user_detail.user_policy_list.flat_map do |policy| # Grab and link policy details
        binding.pry
      end + user_detail.group_list.flat_map do |group| # Link the user id to the groups
        [
          [:link, user_id, :group, group]
        ]
      end + user_detail.attached_managed_policies.flat_map do |attached_policy| # Link up the attached policies
        binding.pry
      end + user_detail.tags.flat_map do |tag| # Link up the tags (or not, undecided just yet)
        binding.pry
      end
    end
  end

end