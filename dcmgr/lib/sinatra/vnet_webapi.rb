# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'vnet_api_client'

module Sinatra
  module VnetWebapi
    def enable_vnet_webapi
      endpoint = Dcmgr::Configurations.dcmgr.features.vnet_endpoint
      port = Dcmgr::Configurations.dcmgr.features.vnet_endpoint_port

      VNetAPIClient.uri = "http://#{endpoint}:#{port}"

      after do
        return if not request.request_method == "POST"

        uuid = self.response.body.first.scan(/nw-.*?"/).uniq.first.gsub(/"/,"")
        if request.path_info == "/networks"
          VNetAPIClient::Network.create(
            uuid: uuid,
            ipv4_network: params[:network],
            ipv4_prefix: params[:prefix],
            network_mode: 'virtual'
          )
        end
      end
    end
  end

  register VnetWebapi
end
