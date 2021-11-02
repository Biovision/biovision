# frozen_string_literal: true

# Adds method for redirects after processed forms
module ProcessedForms
  extend ActiveSupport::Concern

  private

  # @param [String] next_page
  def form_processed_ok(next_page)
    respond_to do |format|
      format.js { render(js: "document.location.href = '#{next_page}'") }
      format.json { render(json: { links: { next: next_page } }) }
      format.html { redirect_to(next_page) }
    end
  end

  # @param [Symbol|String] view_to_render
  # @param [Array] errors
  def form_processed_with_error(view_to_render, errors = [])
    @errors = errors
    respond_to do |format|
      format.js { render('shared/forms/errors', status: :bad_request) }
      format.json { render('shared/forms/errors', status: :bad_request) }
      format.html { render(view_to_render, status: :bad_request) }
    end
  end
end
