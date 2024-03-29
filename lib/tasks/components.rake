# frozen_string_literal: true

namespace :components do
  desc 'Reset role list for all components'
  task reset_role_list: :environment do
    BiovisionComponent.pluck(:slug).each do |component|
      next if component == Biovision::Components::BaseComponent.slug

      handler = Biovision::Components::BaseComponent.handler(component)
      valid_roles = []
      handler.role_tree.each do |prefix, postfixes|
        postfixes.each do |postfix|
          slug = prefix.blank? ? postfix : "#{prefix}.#{postfix}"
          valid_roles << slug
          Role.create(biovision_component: handler.component, slug: slug)
        end
      end

      handler.component.roles.each do |role|
        role.destroy unless valid_roles.include?(role.slug)
      end
    end

    base_component = BiovisionComponent[Biovision::Components::BaseComponent]
    base_roles = %w[admin components.view]
    base_roles.each do |role|
      Role.create(biovision_component: base_component, slug: role)
    end
    base_component.roles.each do |role|
      role.destroy unless base_roles.include?(role.slug)
    end
  end

  desc 'Export all data from each component'
  task export_all: :environment do
    helper = Biovision::Helpers::ExportHelper.new
    [
      Language, MetricValue, Metric, BiovisionComponent, SimpleImageTagImage,
      SimpleImageTag, SimpleImage, UploadedFileTagFile, UploadedFileTag,
      UploadedFile, UserRole, UserGroup, RoleGroup, Role, Group
    ].each do |model|
      helper.export_model(model)
    end
    BiovisionComponent.order(:id).pluck(:slug).each do |slug|
      handler = Biovision::Components::BaseComponent.handler_class(slug)
      handler.dependent_models.each do |model|
        helper.export_model(model)
      end
    end
  end
end
