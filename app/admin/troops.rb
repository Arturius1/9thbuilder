ActiveAdmin.register Troop do
  menu priority: 4

  permit_params :unit_id, :unit_option_id, :troop_type_id, :name, :M, :WS, :BS, :S, :T, :W, :I, :A, :LD, :value_points, :min_size, :position, translations_attributes: [:id, :locale, :name, :_destroy]

  controller do
    def scoped_collection
      super.includes(:translations, unit: [:translations], troop_type: [:translations], unit_option: [:translations])
    end

    def create
      create! { new_admin_troop_url }
    end
  end

  member_action :move_higher, method: :post do
    resource.move_higher
    resource.save

    redirect_to admin_unit_url(resource.unit)
  end

  member_action :move_lower, method: :post do
    resource.move_lower
    resource.save

    redirect_to admin_unit_url(resource.unit)
  end

  action_item :new, only: :show do
    link_to 'New Troop', new_admin_troop_path('troop[unit_id]' => troop.unit)
  end

  filter :unit, collection: proc { Unit.includes(:translations, army: [:translations]).order('army_translations.name', 'unit_translations.name').collect { |r| [r.army.name.to_s + ' - ' + r.name.to_s, r.id] } }
  filter :troop_type, collection: proc { TroopType.includes(:translations) }
  filter :translations_name, as: :string, label: 'Name'
  filter :value_points

  index do
    selectable_column
    id_column
    column :unit, sortable: :unit_id
    column :troop_type, sortable: :troop_type_id
    column :name, sortable: 'troop_translations.name'
    column :unit_option, sortable: :unit_option_id
    column :value_points
    translation_status_flags
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Translated fields' do
      f.translated_inputs '', switch_locale: false do |t|
        t.input :name
      end
    end
    f.inputs 'Common fields' do
      f.input :army_filter, as: :select, collection: Army.includes(:translations).order(:name), disabled: Army.disabled.pluck(:id), label: 'Army FILTER'
      f.input :unit, collection: Unit.includes(:translations, army: [:translations]).order('army_translations.name', 'unit_translations.name').collect { |u| [u.army.name.to_s + ' - ' + u.name.to_s, u.id] }
      f.input :unit_option, collection: UnitOption.includes(:translations, unit: [:translations, { army: [:translations] }]).order('army_translations.name', 'unit_translations.name', 'unit_options.parent_id', 'unit_options.position').collect { |uo| [uo.unit.army.name.to_s + ' - ' + uo.unit.name.to_s + ' - ' + uo.name.to_s, uo.id] }
      f.input :troop_type, collection: TroopType.includes(:translations).order(:name)
      f.input :M
      f.input :WS
      f.input :BS
      f.input :S
      f.input :T
      f.input :W
      f.input :I
      f.input :A
      f.input :LD
      f.input :value_points
      f.input :min_size
      f.input :position
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :unit
      row :unit_option
      row :troop_type
      translated_row :name
      row :M
      row :WS
      row :BS
      row :S
      row :T
      row :W
      row :I
      row :A
      row :LD
      row :value_points
      row :min_size
      row :position
    end
  end
end
