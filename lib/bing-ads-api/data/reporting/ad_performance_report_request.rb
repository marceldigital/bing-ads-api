# -*- encoding : utf-8 -*-
module BingAdsApi

  class AdPerformanceReportRequest < BingAdsApi::PerformanceReportRequest
    # Valid Columns for this report request
    COLUMNS = BingAdsApi::Config.instance.
      reporting_constants['ad_performance_report']['columns']

    # Valid Filters for this report request
    FILTERS = BingAdsApi::Config.instance.
      reporting_constants['ad_performance_report']['filter']

    def initialize(attributes={})
      raise Exception.new('Invalid columns') if !valid_columns(COLUMNS, attributes[:columns])
      raise Exception.new('Invalid filters') if !valid_filter(FILTERS, attributes[:filter])
      raise Exception.new('Invalid scope') if !valid_scope(attributes[:scope])
      super(attributes)
    end

    def to_hash(keys = :underscore)
      hash = super(keys)
      hash[get_attribute_key('columns', keys)] =
        columns_to_hash(COLUMNS, columns, keys)
      hash[get_attribute_key('filter', keys)] =
        filter_to_hash(FILTERS, keys)
      hash[get_attribute_key('scope', keys)] = scope_to_hash(keys)
      hash['@xsi:type'] = type_attribute_for_soap

      hash
    end


    private

    def valid_scope(scope)
      raise Exception.new('Invalid scope: no account_ids key') if !scope.key?(:account_ids)
      true
    end

    def scope_to_hash(keys_case=:underscore)
      {
        get_attribute_key('account_ids', keys_case) => {'ins0:long' => object_to_hash(scope[:account_ids], keys_case)},
        get_attribute_key('campaigns', keys_case) => { 'CampaignReportScope' => object_to_hash(scope[:campaigns], keys_case) },
        get_attribute_key('ad_groups', keys_case) => { 'AdGroupReportScope' =>  object_to_hash(scope[:ad_groups], keys_case) }
      }
    end

    def type_attribute_for_soap
      BingAdsApi::ClientProxy::NAMESPACE.to_s + ':' +
        BingAdsApi::Config.instance.
          reporting_constants['ad_performance_report']['type']
    end

  end
end