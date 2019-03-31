require_relative '../constants'
require_relative '../resource'

class IAM < Resource

  GraphFile = 'iam.pl'

  def initialize(iam_details)
    @iam_details = iam_details
  end

  def facts
    binding.pry
    user_detail_facts + group_detail_facts
    # [
      # [:typed_value, image_id, Cwacop::AWS::AMI],
      # [:typed_value, image_type, Cwacop::AWS::AMIType],
      # [:link, image_id, image_type]
    # ] + block_device_facts
  end

  def group_detail_facts
    binding.pry
  end

  def user_detail_facts
    # Grab all the unique identifiers and give them types and then link them up
    # to the user ID
    @iam_details.user_detail_list.flat_map do |user_detail| # Grab the unique identifiers and link them
      [
        [:typed_value, user_id = user_detail.user_id, Cwacop::AWS::UserId],
        [:typed_value, user_name = user_detail.user_name, Cwacop::AWS::UserName],
        [:typed_value, arn = user_detail.arn, Cwacop::AWS::Arn],
        [:link, user_id, user_name],
        [:link, user_id, arn]
      ] + user_detail.user_policy_list.flat_map do |policy| # Grab and link policy details
        raise StandardError, "Not implemented yet"
      end + user_detail.group_list.flat_map do |group| # Link the user id to the groups
        [
          [:link, user_id, group]
        ]
      end + user_detail.attached_managed_policies.flat_map do |attached_policy| # Link up the attached policies
        raise StandardError, "Not implemented yet"
      end + user_detail.tags.flat_map do |tag| # Link up the tags (or not, undecided just yet)
        raise StandardError, "Not implemented yet"
      end
    end
  end

end