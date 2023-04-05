# frozen_string_literal: true

require 'test/unit'
require 'fileutils'

class PlaywrightRunnerMermaidTest < Test::Unit::TestCase
  def setup
    system('npm install playwright') unless File.exist?('./node_modules/.bin/playwright')
    FileUtils.rm_rf('test/assets/dest')
    FileUtils.mkdir('test/assets/dest')
  end

  def test_mermaid_png
    assert_nothing_raised do
      PlaywrightRunner.mermaids_to_images(
        { playwright_path: './node_modules/.bin/playwright' },
        src: 'test/assets/src', dest: 'test/assets/dest', type: 'png'
      )
    end
    assert File.size('test/assets/dest/p1.png').positive?
    assert File.size('test/assets/dest/p2.png').positive?
    assert !File.exist?('test/assets/dest/p1.pdf')
    assert !File.exist?('test/assets/dest/p2.pdf')
    assert !File.exist?('test/assets/dest/p1.svg')
    assert !File.exist?('test/assets/dest/p2.svg')
    assert !File.exist?('test/assets/dest/__PLAYWRIGHT_TMP__.pdf')
  end

  def test_mermaid_pdf
    assert_nothing_raised do
      PlaywrightRunner.mermaids_to_images(
        { playwright_path: './node_modules/.bin/playwright' },
        src: 'test/assets/src', dest: 'test/assets/dest', type: 'pdf'
      )
    end
    assert File.size('test/assets/dest/p1.pdf').positive?
    assert File.size('test/assets/dest/p2.pdf').positive?
    assert !File.exist?('test/assets/dest/p1.svg')
    assert !File.exist?('test/assets/dest/p2.svg')
    assert !File.exist?('test/assets/dest/__PLAYWRIGHT_TMP__.pdf')
  end

  def test_mermaid_pdf_pdfcrop
    # skip
    return unless system('pdfcrop --version')

    assert_nothing_raised do
      PlaywrightRunner.mermaids_to_images(
        { playwright_path: './node_modules/.bin/playwright', selfcrop: false },
        src: 'test/assets/src', dest: 'test/assets/dest', type: 'pdf'
      )
    end
    assert File.size('test/assets/dest/p1.pdf').positive?
    assert File.size('test/assets/dest/p2.pdf').positive?
    assert !File.exist?('test/assets/dest/p1.svg')
    assert !File.exist?('test/assets/dest/p2.svg')
    assert !File.exist?('test/assets/dest/__PLAYWRIGHT_TMP__.pdf')
  end

  def test_mermaid_svg
    # skip
    return unless system('pdftocairo -v')

    assert_nothing_raised do
      PlaywrightRunner.mermaids_to_images(
        { playwright_path: './node_modules/.bin/playwright' },
        src: 'test/assets/src', dest: 'test/assets/dest', type: 'svg'
      )
    end
    assert File.size('test/assets/dest/p1.svg').positive?
    assert File.size('test/assets/dest/p2.svg').positive?
    assert !File.exist?('test/assets/dest/p1.pdf')
    assert !File.exist?('test/assets/dest/p2.pdf')
    assert !File.exist?('test/assets/dest/__PLAYWRIGHT_TMP__.pdf')
  end

  def test_mermaid_svg_pdfcrop
    # skip
    return if !system('pdftocairo -v') || !system('pdfcrop --version')

    assert_nothing_raised do
      PlaywrightRunner.mermaids_to_images(
        { playwright_path: './node_modules/.bin/playwright', selfcrop: false },
        src: 'test/assets/src', dest: 'test/assets/dest', type: 'svg'
      )
    end
    assert File.size('test/assets/dest/p1.svg').positive?
    assert File.size('test/assets/dest/p2.svg').positive?
    assert !File.exist?('test/assets/dest/p1.pdf')
    assert !File.exist?('test/assets/dest/p2.pdf')
    assert !File.exist?('test/assets/dest/__PLAYWRIGHT_TMP__.pdf')
  end
end
