# Playwright Runner
# Copyright 2023 Kenshi Muto
# frozen_string_literal: true

require_relative 'playwrightrunner/version'

require 'playwright'
require 'open3'
require 'fileutils'

module PlaywrightRunner
  def complement_config(config)
    config[:playwright_path] ||= './node_modules/.bin/playwright'
    config[:pdfcrop_path] ||= 'pdfcrop'
    config[:pdftocairo_path] ||= 'pdftocairo'

    config
  end

  def mermaids_to_images(config, src: '.', dest: '.', type: 'pdf')
    Playwright.create(playwright_cli_executable_path: config[:playwright_path]) do |playwright|
      playwright.chromium.launch(headless: true) do |browser|
        page = browser.new_page
        Dir.glob(File.join(src, '*.html')).each do |entry|
          id = File.basename(entry).sub('.html', '')
          page.goto("file:///#{File.absolute_path(entry)}")
          page.locator('svg').click # to wait drawn

          page.pdf(path: File.join(dest, '__PLAYWRIGHT_TMP__.pdf'))
          Open3.capture2e(config[:pdfcrop_path],
                          File.join(dest, '__PLAYWRIGHT_TMP__.pdf'),
                          File.join(dest, "#{id}.pdf"))

          next unless type == 'svg'

          Open3.capture2e(config[:pdftocairo_path],
                          '-svg',
                          File.join(dest, "#{id}.pdf"),
                          File.join(dest, "#{id}.svg"))
          FileUtils.rm_f(File.join(dest, "#{id}.pdf"))
        end

        FileUtils.rm_f(File.join(dest, '__PLAYWRIGHT_TMP__.pdf'))
      end
    end
  end

  module_function :complement_config, :mermaids_to_images
end
