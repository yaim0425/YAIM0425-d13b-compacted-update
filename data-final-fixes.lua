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
            This_MOD.create_recipe(space)
            This_MOD.create_tech(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- Fijar las posiciones actual
    GMOD.d00b.change_orders()

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





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en este MOD
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Lista de entidades a ignorar
    This_MOD.ignore_to_name = {
        --- Space Exploration
        ["se-space-pipe-long-j-3"] = true,
        ["se-space-pipe-long-j-5"] = true,
        ["se-space-pipe-long-j-7"] = true,
        ["se-space-pipe-long-s-9"] = true,
        ["se-space-pipe-long-s-15"] = true,

        ["se-condenser-turbine"] = true,
        ["se-energy-transmitter-emitter"] = true,
        ["se-energy-transmitter-injector"] = true,
        ["se-core-miner-drill"] = true,

        ["se-delivery-cannon"] = true,
        ["se-spaceship-rocket-engine"] = true,
        ["se-spaceship-ion-engine"] = true,
        ["se-spaceship-antimatter-engine"] = true,

        ["se-meteor-point-defence-container"] = true,
        ["se-meteor-defence-container"] = true,
        ["se-delivery-cannon-weapon"] = true,
        ["shield-projector"] = true
    }

    --- Funciones basicas
    local function return_entity(space) return space.entity end
    local function return_equipment(space) return space.equipment end

    --- Validar por tipo
    This_MOD.validate_to_type = {
        --- Entities
        ["assembling-machine"] = return_entity,
        ["beacon"] = return_entity,
        ["boiler"] = return_entity,
        ["cargo-wagon"] = return_entity,
        ["construction-robot"] = return_entity,
        ["electric-turret"] = return_entity,
        ["fluid-wagon"] = return_entity,
        ["furnace"] = return_entity,
        ["gate"] = return_entity,
        ["generator"] = return_entity,
        ["inserter"] = return_entity,
        ["lab"] = return_entity,
        ["lane-splitter"] = return_entity,
        ["loader-1x1"] = return_entity,
        ["locomotive"] = return_entity,
        ["logistic-robot"] = return_entity,
        ["mining-drill"] = return_entity,
        ["pipe-to-ground"] = return_entity,
        ["pump"] = return_entity,
        ["radar"] = return_entity,
        ["reactor"] = return_entity,
        ["repair-tool"] = return_entity,
        ["solar-panel"] = return_entity,
        ["splitter"] = return_entity,
        ["storage-tank"] = return_entity,
        ["transport-belt"] = return_entity,
        ["underground-belt"] = return_entity,
        ["wall"] = return_entity,

        ["accumulator"] = function(space)
            if not space.entity.energy_source then return end
            if not space.entity.energy_source.output_flow_limit then return end
            local Energy = space.entity.energy_source.output_flow_limit
            Energy = GMOD.number_unit(Energy)
            if not Energy then return end
            return space.entity
        end,

        --- Tile
        ["tile"] = function(space) return space.title end,

        --- Items
        ["ammo"] = function(space) return space.ammo end,
        ["module"] = function(space) return space.module end,

        --- Equipment
        ["active-defense-equipment"] = return_equipment,
        ["battery-equipment"] = return_equipment,
        ["roboport-equipment"] = return_equipment,
        ["generator-equipment"] = return_equipment,
        ["solar-panel-equipment"] = return_equipment,
        ["energy-shield-equipment"] = return_equipment,
        ["movement-bonus-equipment"] = return_equipment,
    }

    --- Efectos por tipo
    This_MOD.effect_to_type = {
        --- Entities
        ["accumulator"] = function(space, Entity)
        end,

        ["assembling-machine"] = function(space, Entity)
        end,

        ["beacon"] = function(space, Entity)
        end,

        ["boiler"] = function(space, Entity)
        end,

        ["cargo-wagon"] = function(space, Entity)
        end,

        ["construction-robot"] = function(space, Entity)
            Entity.speed = space.amount * Entity.speed
            Entity.max_payload_size = space.amount * Entity.max_payload_size
        end,

        ["electric-turret"] = function(space, Entity)
        end,

        ["fluid-wagon"] = function(space, Entity)
        end,

        ["furnace"] = function(space, Entity)
        end,

        ["gate"] = function(space, Entity)
        end,

        ["generator"] = function(space, Entity)
        end,

        ["inserter"] = function(space, Entity)
        end,

        ["lab"] = function(space, Entity)
        end,

        ["lane-splitter"] = function(space, Entity)
        end,

        ["loader-1x1"] = function(space, Entity)
        end,

        ["locomotive"] = function(space, Entity)
        end,

        ["logistic-robot"] = function(space, Entity)
            Entity.speed = space.amount * Entity.speed
            Entity.max_payload_size = space.amount * Entity.max_payload_size
        end,

        ["mining-drill"] = function(space, Entity)
        end,

        ["pipe-to-ground"] = function(space, Entity)
        end,

        ["pump"] = function(space, Entity)
        end,

        ["radar"] = function(space, Entity)
        end,

        ["reactor"] = function(space, Entity)
        end,

        ["repair-tool"] = function(space, Entity)
        end,

        ["solar-panel"] = function(space, Entity)
            local Value, Unit = GMOD.number_unit(Entity.production)
            Entity.production = (space.amount * Value) .. Unit
        end,

        ["splitter"] = function(space, Entity)
        end,

        ["storage-tank"] = function(space, Entity)
            Entity.fluid_box.volume = space.amount * Entity.fluid_box.volume
        end,

        ["transport-belt"] = function(space, Entity)
        end,

        ["underground-belt"] = function(space, Entity)
        end,

        ["wall"] = function(space, Entity)
        end
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

    local function validate_recipe(recipe)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Validar el tipo
        if recipe.type ~= "recipe" then return end
        if not GMOD.has_id(recipe.name, d12b.id) then return end
        if not GMOD.has_id(recipe.name, d12b.category_do) then return end

        --- Validar contenido
        if #recipe.ingredients ~= 1 then return end
        if #recipe.results ~= 1 then return end

        --- Renombrar
        local Item = GMOD.items[recipe.ingredients[1].name]
        local Item_do = GMOD.items[recipe.results[1].name]

        --- Calcular la cantidad
        local Amount = d12b.setting.amount
        if d12b.setting.stack_size then
            Amount = Amount * Item.stack_size
            if Amount > 65000 then
                Amount = 65000
            end
        end

        --- Validar si ya fue procesado
        local That_MOD =
            GMOD.get_id_and_name(Item_do.name) or
            { ids = "-", name = Item_do.name }

        local Name =
            GMOD.name .. That_MOD.ids ..
            This_MOD.id .. "-" ..
            That_MOD.name

        if GMOD.items[Name] then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Valores para el proceso
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Space = {}

        Space.name = Name

        Space.item = Item
        Space.amount = Amount
        Space.item_do = Item_do

        Space.prefix =
            GMOD.name .. That_MOD.ids ..
            This_MOD.id .. "-" .. (
                d12b.setting.stack_size and
                Item.stack_size .. "x" .. d12b.setting.amount or
                Amount
            ) .. "u-"

        Space.recipe_do = recipe
        Space.recipe_undo = recipe.name:gsub(
            d12b.category_do .. "%-",
            d12b.category_undo .. "-"
        )
        Space.recipe_undo = data.raw.recipe[Space.recipe_undo]

        Space.tech = GMOD.get_technology({ Space.recipe_undo }, true)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if Item.place_as_tile then
            -- Space.title = GMOD.entities[Item.place_as_tile]
            return
        elseif Item.place_result then
            Space.entity = GMOD.entities[Item.place_result]
            if not Space.entity then return end
            if This_MOD.ignore_to_name[Space.entity.name] then return end
            local Validate = This_MOD.validate_to_type[Space.entity.type]
            if not Validate then return end
            Space.entity = Validate(Space)
            if not Space.entity then return end

            Space.localised_name = Space.entity.localised_name
            Space.localised_description = Space.entity.localised_description
        elseif Item.place_as_equipment_result then
            -- Space.equipment = GMOD.equipments[Item.place_as_equipment_result]
            return
        else
            return
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        This_MOD.to_be_processed[recipe.type] = This_MOD.to_be_processed[recipe.type] or {}
        This_MOD.to_be_processed[recipe.type][Name] = Space

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Preparar los datos a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(data.raw.recipe) do
        validate_recipe(recipe)
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
    Item.localised_name = GMOD.copy(space.localised_name)
    Item.localised_description = GMOD.copy(space.localised_description)

    --- Entidad a crear
    Item.place_result = space.name

    --- Agregar indicador del MOD
    Item.icons = GMOD.copy(space.item_do.icons)
    local Icon = GMOD.get_tables(Item.icons, "icon", d12b.indicator.icon)[1]
    Icon.icon = This_MOD.indicator.icon

    --- Actualizar subgroup y order
    Item.subgroup = space.item_do.subgroup
    Item.order = space.item_do.order

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Eliminar el objeto anterior
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.items[space.item_do.name] = nil
    data.raw.item[space.item_do.name] = nil

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
    Entity.localised_name = GMOD.copy(space.localised_name)
    Entity.localised_description = GMOD.copy(space.localised_description)

    --- Elimnar propiedades inecesarias
    Entity.factoriopedia_simulation = nil

    --- Cambiar icono
    Entity.icons = GMOD.items[space.name].icons

    --- Actualizar el nuevo subgrupo
    Entity.subgroup = GMOD.items[space.name].subgroup

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
        local Name = space.prefix .. (
            GMOD.get_id_and_name(entity) or
            { name = entity }
        ).name

        --- La entidad ya existe
        if GMOD.entities[Name] then return Name end

        --- La entidad existirá
        for _, Spaces in pairs(This_MOD.to_be_processed) do
            for _, Space in pairs(Spaces) do
                if Space.entity and Space.entity.name == entity then
                    return Name
                end
            end
        end
    end)(Entity.next_upgrade)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Aplicar el efecto apropiado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.effect_to_type[Entity.type](space, Entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_recipe(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.recipe_do then return end
    if not space.recipe_undo then return end

    if data.raw.recipe[space.recipe_do] then return end
    if data.raw.recipe[space.recipe_undo] then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    space.recipe_do.results[1].name = space.name
    space.recipe_undo.ingredients[1].name = space.name

    GMOD.recipes[space.name] = GMOD.recipes[space.item_do.name]
    GMOD.recipes[space.item_do.name] = nil

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_tech(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.tech then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    space.tech.research_trigger.item = space.name

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------





---------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------

local Table = {}
for key, _ in pairs(This_MOD.effect_to_type) do
    table.insert(Table, key)
end
table.sort(Table)
GMOD.var_dump(Table)
