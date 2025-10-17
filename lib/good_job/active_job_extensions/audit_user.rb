# frozen_string_literal: true

module GoodJob
  module ActiveJobExtensions
    module AuditUser
      extend ActiveSupport::Concern

      module Prepends
        def enqueue(options = {})
          self.good_job_audit_user = options[:good_job_audit_user] if options.key?(:good_job_audit_user)
          super
        end

        def serialize
          super.tap do |job_data|
            job_data["good_job_audit_user"] = good_job_audit_user unless good_job_audit_user.nil?
          end
        end

        def deserialize(job_data)
          super
          self.good_job_audit_user = job_data["good_job_audit_user"]
        end
      end

      included do
        prepend Prepends
        class_attribute :good_job_audit_user, instance_accessor: false, instance_predicate: false, default: nil
        attr_accessor :good_job_audit_user
      end
    end
  end
end
