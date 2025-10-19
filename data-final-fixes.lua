---------------------------------------------------------------------------
---[ data-final-fixes.lua ]---
---------------------------------------------------------------------------





---------------------------------------------------------------------------
---[ Cargar dependencias ]---
---------------------------------------------------------------------------

local d12b = GMOD.d12b
if not d12b then return end

---------------------------------------------------------------------------





---------------------------------------------------------------------------
---[ Información del MOD ]---
---------------------------------------------------------------------------

local This_MOD = GMOD.get_id_and_name()
if not This_MOD then return end
GMOD[This_MOD.id] = This_MOD

---------------------------------------------------------------------------

function This_MOD.start()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valores de la referencia
    This_MOD.reference_values()

    --- Obtener los elementos
    This_MOD.get_elements()

    --- Modificar los elementos
    for _, spaces in pairs(This_MOD.to_be_processed) do
        for _, space in pairs(spaces) do
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Crear los elementos
            This_MOD.create_item(space)
            This_MOD.create_entity(space)
            -- This_MOD.create_recipe(space)
            -- This_MOD.create_tech(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Contenedor de los elementos que el MOD modoficará
    This_MOD.to_be_processed = {}

    --- Validar si se cargó antes
    if This_MOD.setting then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cargar la configuración
    This_MOD.setting = GMOD.setting[This_MOD.id] or {}

    --- Indicador del mod
    This_MOD.indicator = {
        icon  = GMOD.signal["star"],
        shift = { 14, -14 }
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------





---------------------------------------------------------------------------
---[ Cambios del MOD ]---
---------------------------------------------------------------------------

function This_MOD.get_elements()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Función para analizar cada entidad
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function valide_recipe(recipe)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Validar el tipo
        if recipe.type ~= "recipe" then return end
        if not GMOD.has_id(recipe.name, d12b.id) then return end

        --- Validar contenido
        if #recipe.ingredients ~= 1 then return end
        if #recipe.results ~= 1 then return end

        --- Renombrar
        local Result = GMOD.items[recipe.results[1].name]
        local Ingredient = GMOD.items[recipe.ingredients[1].name]

        --- Validar si ya fue procesado
        local Space = {}
        Space = This_MOD.to_be_processed[recipe.type] or {}
        Space = Space[Ingredient.name] or {}
        if Space.recipe_do == recipe then return end
        if Space.recipe_undo == recipe then return end

        local Name = recipe.name:gsub(d12b.id .. "%-", This_MOD.id .. "-")
        Name = Name:gsub(d12b.category_do .. "%-", "")
        Name = Name:gsub(d12b.category_undo .. "%-", "")
        if GMOD.items[Name] then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Valores para el proceso
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        Space.name = Space.name or Name

        if GMOD.has_id(recipe.name, d12b.category_do) then
            Space.recipe_do = recipe
            Space.item_do = Space.item_do or Result
            Space.item = Space.item or Ingredient
        end

        if GMOD.has_id(recipe.name, d12b.category_undo) then
            Space.recipe_undo = recipe
            Space.item_do = Space.item_do or Ingredient
            Space.item = Space.item or Result
        end

        if Space.item.place_as_tile then
            Space.title = Space.title or GMOD.entities[Space.item.place_as_tile]
            return
        elseif Space.item.place_result then
            Space.entity = Space.entity or GMOD.entities[Space.item.place_result]
        elseif Space.item.place_as_equipment_result then
            Space.equipment = Space.equipment or GMOD.equipments[Space.item.place_as_equipment_result]
            return
        else
            return
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        This_MOD.to_be_processed[recipe.type] = This_MOD.to_be_processed[recipe.type] or {}
        This_MOD.to_be_processed[recipe.type][Ingredient.name] = Space
        This_MOD.to_be_processed[recipe.type][Result.name] = Space

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Preparar los datos a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(data.raw.recipe) do
        valide_recipe(recipe)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------

function This_MOD.create_item(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.item then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Item = GMOD.copy(space.item)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nombre
    Item.name = space.name

    --- Apodo y descripción
    Item.localised_name = GMOD.copy(space.entity.localised_name)
    Item.localised_description = GMOD.copy(space.entity.localised_description)

    --- Entidad a crear
    Item.place_result = space.name

    --- Agregar indicador del MOD
    local Icon = GMOD.get_tables(Item.icons, "icon", d12b.indicator.icon)[1]
    Icon.icon = This_MOD.indicator.icon

    --- Nombre del nuevo subgrupo
    Item.subgroup = Item.subgroup:gsub(d12b.id .. "%-", This_MOD.id .. "-")

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear el subgrupo para el objeto
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Duplicar el subgrupo
    if not GMOD.subgroups[Item.subgroup] then
        GMOD.duplicate_subgroup(space.item.subgroup, Item.subgroup)

        --- Renombrar
        local Subgroup = GMOD.subgroups[Item.subgroup]
        local Order = GMOD.subgroups[space.item.subgroup].order

        --- Actualizar el order
        Subgroup.order = 1 .. Order:sub(2)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Eliminar el objeto anterior
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    -- GMOD.items[space.item_do.name] = nil
    -- data.raw.item[space.item_do.name] = nil

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Item)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_entity(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.entity then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Entity = GMOD.copy(space.entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nombre
    Entity.name = space.name

    --- Apodo y descripción
    Entity.localised_name = GMOD.copy(space.entity.localised_name)
    Entity.localised_description = GMOD.copy(space.entity.localised_description)

    --- Elimnar propiedades inecesarias
    Entity.factoriopedia_simulation = nil

    --- Cambiar icono
    Entity.icons = GMOD.items[space.name].icons

    --- Objeto a minar
    Entity.minable.results = { {
        type = "item",
        name = space.name,
        amount = 1
    } }

    --- Siguiente tier
    Entity.next_upgrade = (function(entity)
        --- Validación
        if not entity then return end

        --- Nombre despues del aplicar el MOD
        local Name = entity:gsub(d12b.id .. "%-", This_MOD.id .. "-")

        --- La entidad ya existe
        if GMOD.entities[Name] then
            return Name
        end

        --- La entidad existirá
        for _, Spaces in pairs(This_MOD.to_be_processed) do
            for _, Space in pairs(Spaces) do
                if Space.entity.name == entity then
                    return Name
                end
            end
        end
    end)(Entity.next_upgrade)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------





---------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------
