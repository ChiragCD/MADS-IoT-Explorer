defmodule AcqdatCore.Repo.Migrations.AddStreamLogicWorkflow do
  use Ecto.Migration

  def change do
    create table("acqdat_sl_workflow") do
      add(:name, :string, null: false)
      add(:digraph, :map, null: false)
      add(:uuid, :string, null: false)
      add(:enabled, :boolean, default: true)

      #associations
      add(:project_id, references("acqdat_projects", on_delete: :delete_all),
        null: false)
      belongs_to(:org, references("acqdat_organisation", on_delete: :delete_all),
        null: false)

      timestamps(type: :timestamptz)
    end
  end
end
