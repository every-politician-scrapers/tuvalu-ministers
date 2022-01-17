#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def position
      name_first? ? info.gsub('Profile: ', '') : lead
    end

    def name
      return nodes[2].text.tidy if position == 'HEAD OF STATE'

      (name_first? ? lead : info).gsub('Hon. ', '')
    end

    private

    def nodes
      noko.xpath('text()')
    end

    def lead
      nodes.first.text.tidy
    end

    def info
      nodes[1]&.text.to_s.tidy
    end

    def name_first?
      info.empty? || info[/Profile:/]
    end
  end

  class Members
    def member_container
      noko.css('.entry-content').xpath('.//figure[img]//following::p[1]')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv if file.exist? && !file.empty?
