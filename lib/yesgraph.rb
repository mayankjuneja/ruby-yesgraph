# frozen_string_literal: true

require 'yesgraph/version'
require 'uri'
require 'rest-client'
require 'json'
require 'cgi'

BASE_URL = 'https://api.yesgraph.com/v0/'

module Yesgraph
  class YesGraphAPI
    # Wrapper Class
    attr_reader :secret_key, :base_url
    def initialize(secret_key, base_url = BASE_URL)
      @secret_key = secret_key
      @base_url = base_url
    end

    def user_agent
      client_info = ['ruby-yesgraph', Yesgraph::VERSION].join('-')
      host_info = RbConfig::CONFIG['host']
      language_info = RbConfig::CONFIG['RUBY_VERSION_NAME']
      [client_info, host_info, language_info].join(' ')
    end

    def build_url(endpoint, url_args = {})
      base_url_cleaned = base_url.sub(%r{\/+$}, '')
      endpoint_cleaned = endpoint.sub(%r{^\/+}, '')
      url = [base_url_cleaned, endpoint_cleaned].join('/')
      url_args.delete_if { |_, v| v.to_s.strip.empty? }
      unless url_args.empty?
        args = URI.encode_www_form(url_args)
        url = "#{url}?#{args}"
      end
      url
    end

    def request(method, endpoint, data = {}, url_args = {})
      # Builds and sends the complete request.
      headers = {
        'Authorization' => "Bearer #{secret_key}",
        'Content-Type' => 'application/json',
        'User-Agent' => user_agent
      }

      url = build_url(endpoint, url_args)
      resp = RestClient::Request.execute(method: method, url: url,
                                         payload: data.to_s,
                                         headers: headers)
      JSON.parse(resp.body)
    end

    def test
      # Wrapped method for GET of /test endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/test

      request(:get, '/test')
    end

    def get_client_key(user_id)
      # Wrapped method for POST of /client-key endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/create-client-keys

      data = JSON.dump('user_id': user_id.to_s)
      result = request(:post, '/client-key', data)
      result['client_key']
    end

    def post_address_book(user_id, entries, source_type, source_name: nil,
                          source_email: nil, filter_suggested_seen: nil,
                          filter_existing_users: nil,
                          filter_invites_sent: nil,
                          filter_blank_names: nil,
                          promote_existing_users: nil,
                          promote_matching_domain: nil,
                          backfill: nil,
                          limit: nil)
      # Wrapped method for POST of /address-book endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/address-book

      source = { 'type' => source_type }
      source['name'] = source_name if source_name
      source['email'] = source_email if source_email

      raise('`limit` param is not an int') unless limit.nil? ||
                                                  (limit.is_a? Integer)
      raise('`backfill` param is not an int') unless backfill.nil? ||
                                                     (backfill.is_a? Integer)

      data = {
        'user_id' => user_id.to_s,
        'filter_suggested_seen' => filter_suggested_seen,
        'filter_existing_users' => filter_existing_users,
        'filter_invites_sent' => filter_invites_sent,
        'filter_blank_names' => filter_blank_names,
        'promote_existing_users' => promote_existing_users,
        'promote_matching_domain' => promote_matching_domain,
        'source' => source,
        'entries' => entries,
        'limit' => limit,
        'backfill' => backfill
      }
      data = JSON.dump(data)
      request(:post, '/address-book', data)
    end

    def get_address_book(user_id, filter_suggested_seen: nil,
                         filter_existing_users: nil,
                         filter_invites_sent: nil,
                         promote_existing_users: nil,
                         promote_matching_domain: nil,
                         filter_blank_names: nil,
                         limit: nil)
      # Wrapped method for GET of /address-book endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/address-book#section-get-address-bookuser_id

      raise('`limit` param is not an int') unless limit.nil? ||
                                                  (limit.is_a? Integer)

      urlargs = {
        'filter_suggested_seen' => filter_suggested_seen,
        'filter_existing_users' => filter_existing_users,
        'filter_invites_sent' => filter_invites_sent,
        'filter_blank_names' => filter_blank_names,
        'promote_existing_users' => promote_existing_users,
        'promote_matching_domain' => promote_matching_domain,
        'limit' => limit
      }

      user_id = CGI.escape(user_id.to_s)
      endpoint = "/address-book/#{user_id}"
      request(:get, endpoint, {}, urlargs)
    end

    def delete_address_book(user_id)
      # Wrapped method for DELETE /address-book/:user_id endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/address-book#section-delete-address-bookuser_id

      user_id = CGI.escape(user_id.to_s)
      endpoint = "/address-book/#{user_id}"
      request(:delete, endpoint)
    end

    def post_invites_accepted(entries)
      # Wrapped method for POST of /invites-accepted endpoint
      #
      #  Documentation - https://docs.yesgraph.com/docs/invites-accepted

      raise('An entry list is required') unless entries && (entries.is_a? Array)
      data = { 'entries' => entries }
      data = JSON.dump(data)
      request(:post, '/invites-accepted', data)
    end

    def post_invites_sent(entries)
      # Wrapped method for POST of /invites-sent endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/invites-sent

      raise('An entry list is required') unless entries && (entries.is_a? Array)
      data = { 'entries' => entries }
      data = JSON.dump(data)
      request(:post, '/invites-sent', data)
    end

    def post_suggested_seen(entries)
      # Wrapped method for POST of /suggested-seen endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/suggested-seen

      raise('An entry list is required') unless entries && (entries.is_a? Array)
      data = { 'entries' => entries }
      data = JSON.dump(data)
      request(:post, '/suggested-seen', data)
    end

    def post_users(users)
      # Wrapped method for POST of users endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/users

      data = JSON.dump(users)
      request(:post, '/users', data)
    end

    def get_domain_emails(domain, page: nil, batch_size: nil)
      # Wrapped method for GET of /domain-emails/<domain> endpoint
      #
      # Documentation - https://docs.yesgraph.com/docs/domain-emails/

      urlargs = { 'page' => page, 'batch_size' => batch_size }

      domain = CGI.escape(domain.to_s)
      endpoint = "/domain-emails/#{domain}"
      request(:get, endpoint, {}, urlargs)
    end
  end
end
