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

    --- Efectos a duplicar
    This_MOD.finds = { "beam", "projectile" }

    --- Efectos por tipo
    This_MOD.effect_to_type = {
        --- Entities
        ["accumulator"] = function(space, entity)
            if not entity.energy_source then return end
            local energy = entity.energy_source
            for _, propiety in pairs({
                "buffer_capacity",
                "input_flow_limit",
                "output_flow_limit"
            }) do
                local Value, Unit = GMOD.number_unit(energy[propiety])
                energy[propiety] = (space.amount * Value) .. Unit
            end
        end,

        ["assembling-machine"] = function(space, entity)
        end,

        ["artillery-turret"] = function(space, entity)
            if entity.turret_rotation_speed then
                entity.turret_rotation_speed = space.amount * entity.turret_rotation_speed
            end
        end,

        ["artillery-wagon"] = function(space, entity)
            entity.max_speed = space.amount * entity.max_speed

            if entity.turret_rotation_speed then
                entity.turret_rotation_speed = space.amount * entity.turret_rotation_speed
            end
        end,

        ["beacon"] = function(space, entity)
        end,

        ["boiler"] = function(space, entity)
        end,

        ["cargo-wagon"] = function(space, entity)
            entity.max_speed = space.amount * entity.max_speed

            if entity.inventory_size then
                entity.inventory_size = space.amount * entity.inventory_size
                if entity.inventory_size > 65535 then
                    entity.inventory_size = 65535
                end
            end
        end,

        ["construction-robot"] = function(space, entity)
            entity.speed = space.amount * entity.speed
            entity.max_payload_size = space.amount * entity.max_payload_size
        end,

        ["electric-turret"] = function(space, entity)
            --- Velocidad de respues
            entity.rotation_speed = space.amount * entity.rotation_speed
            entity.preparing_speed = space.amount * entity.preparing_speed

            --- Daño directo
            local damages = GMOD.get_tables(entity.attack_parameters, "type", "damage")
            for _, element in pairs(damages or {}) do
                if element.damages.amount then
                    element.damage.amount = space.amount * element.damage.amount
                end
            end

            --- Daño indirecto
            local Action = entity.attack_parameters.ammo_type.action
            for _, type in pairs(This_MOD.finds) do
                for _, Table in pairs(
                    GMOD.get_tables(Action, "type", type) or {}
                ) do
                    repeat
                        --- Validación
                        if GMOD.has_id(Table[type], This_MOD.id) then break end
                        local Effecto = data.raw[type][Table[type]]
                        if not Effecto then break end

                        --- Duplicar el efecto
                        Effecto = GMOD.copy(Effecto)

                        --- Actualizar el nombre
                        local That_MOD =
                            GMOD.get_id_and_name(Effecto.name) or
                            { ids = "-", name = Effecto.name }

                        Effecto.name =
                            GMOD.name .. That_MOD.ids ..
                            This_MOD.id .. "-" ..
                            That_MOD.name .. "-" ..
                            space.amount .. "x"

                        Table[type] = Effecto.name

                        --- Aumentar el daño
                        for _, element in pairs(
                            GMOD.get_tables(Effecto, "type", "damage") or {}
                        ) do
                            if element.damage.amount then
                                element.damage.amount = space.amount * element.damage.amount
                            end
                        end

                        --- Crear y devolver el effecto
                        GMOD.extend(Effecto)
                    until true
                end
            end
        end,

        ["fluid-wagon"] = function(space, entity)
            entity.max_speed = space.amount * entity.max_speed

            if entity.capacity then
                entity.capacity = space.amount * entity.capacity
            end
        end,

        ["furnace"] = function(space, entity)
        end,

        ["gate"] = function(space, entity)
        end,

        ["generator"] = function(space, entity)
        end,

        ["inserter"] = function(space, entity)
        end,

        ["lab"] = function(space, entity)
        end,

        ["lane-splitter"] = function(space, entity)
            --- Velocidad de la cintas
            entity.speed = (space.belt or space.amount) * entity.speed

            --- Velocidad de la animación
            local Fact = entity.speed / space.entity.speed
            entity.animation_speed_coefficient = entity.animation_speed_coefficient / Fact
        end,

        ["loader-1x1"] = function(space, entity)
            --- Velocidad de la cintas
            entity.speed = (space.belt or space.amount) * entity.speed

            --- Velocidad de la animación
            local Fact = entity.speed / space.entity.speed
            entity.animation_speed_coefficient = entity.animation_speed_coefficient / Fact
        end,

        ["locomotive"] = function(space, entity)
            entity.max_speed = space.amount * entity.max_speed

            local energy = entity.energy_source
            if energy and energy.type == "burner" then
                energy.effectivity = space.amount * (energy.effectivity or 1)
            end

            if entity.max_power then
                local Value, Unit = GMOD.number_unit(entity.max_power)
                entity.max_power = (space.amount * Value) .. Unit
            end
        end,

        ["logistic-robot"] = function(space, entity)
            entity.speed = space.amount * entity.speed
            entity.max_payload_size = space.amount * entity.max_payload_size
        end,

        ["mining-drill"] = function(space, entity)
            if not entity.energy_source then return end
            local energy = entity.energy_source
            if energy.type == "burner" then
                energy.effectivity = space.amount * (energy.effectivity or 1)
            end
            entity.mining_speed = space.amount * entity.mining_speed
        end,

        ["pipe-to-ground"] = function(space, entity)
            if not entity.fluid_box then return end
            if not entity.fluid_box.pipe_connections then return end
            local pipe_connections = entity.fluid_box.pipe_connections
            for _, value in pairs(pipe_connections) do
                if value.max_underground_distance then
                    value.max_underground_distance =
                        space.amount * value.max_underground_distance
                    if value.max_underground_distance > 255 then
                        value.max_underground_distance = 255
                    end
                end
            end
        end,

        ["pump"] = function(space, entity)
            if not entity.pumping_speed then return end
            entity.pumping_speed = space.amount * entity.pumping_speed
        end,

        ["reactor"] = function(space, entity)
            local energy = entity.energy_source
            if energy.type ~= "burner" then return end
            energy.effectivity = space.amount * (energy.effectivity or 1)
        end,

        ["solar-panel"] = function(space, entity)
            local Value, Unit = GMOD.number_unit(entity.production)
            entity.production = (space.amount * Value) .. Unit
        end,

        ["splitter"] = function(space, entity)
            --- Velocidad de la cintas
            entity.speed = space.amount * entity.speed

            --- Velocidad de la animación
            local Fact = entity.speed / space.entity.speed
            entity.animation_speed_coefficient = entity.animation_speed_coefficient / Fact
        end,

        ["storage-tank"] = function(space, entity)
            entity.fluid_box.volume = space.amount * entity.fluid_box.volume
        end,

        ["transport-belt"] = function(space, entity)
            --- Velocidad de la cintas
            entity.speed = space.amount * entity.speed

            --- Velocidad de la animación
            local Fact = entity.speed / space.entity.speed
            entity.animation_speed_coefficient = entity.animation_speed_coefficient / Fact

            --- Cinta subterranea a usar
            if not entity.related_underground_belt then return end
            local Item = GMOD.items[entity.related_underground_belt]
            entity.related_underground_belt =
                GMOD.name .. (
                    GMOD.get_id_and_name(entity.name) or
                    { ids = "-" .. This_MOD.id .. "-" }
                ).ids .. (
                    d12b.setting.stack_size and
                    Item.stack_size .. "x" .. d12b.setting.amount or
                    space.amount
                ) .. "u-" .. (
                    GMOD.get_id_and_name(entity.related_underground_belt) or
                    { name = entity.related_underground_belt }
                ).name
        end,

        ["underground-belt"] = function(space, entity)
            --- Velocidad de la cintas
            entity.speed = (space.belt or space.amount) * entity.speed

            --- Velocidad de la animación
            local Fact = entity.speed / space.entity.speed
            entity.animation_speed_coefficient = entity.animation_speed_coefficient / Fact

            --- Distancia
            if not entity.max_distance then return end
            if entity.max_distance == 0 then return end
            entity.max_distance = entity.max_distance + 2 * ((space.belt or space.amount) - 1)
            if entity.max_distance > 255 then entity.max_distance = 255 end
        end,

        ["wall"] = function(space, entity)
        end,

        --- Items
        ["ammo"] = function(space, item)
        end,

        ["module"] = function(space, item)
            for key, _ in pairs(item.effect) do
                if key ~= "consumption" or (key == "consumption" and item.effect[key] < 0) then
                    item.effect[key] = space.amount * item.effect[key]
                end
                if item.effect[key] > 327 then item.effect[key] = 327 end
                if item.effect[key] < -327 then item.effect[key] = -327 end
            end
        end,

        ["repair-tool"] = function(space, item)
            item.speed = space.amount * item.speed
            item.durability = space.amount * item.durability
        end,

        --- Tile
        ["tile"] = function(space, tile)
            local i = space.amount - 1
            local pollution = 0
            local spores = 0

            if tile.absorptions_per_second then
                pollution = tile.absorptions_per_second.pollution or 0.005
                if mods["space-age"] then
                    spores = tile.absorptions_per_second.spores or 0.005
                end
            end

            tile.absorptions_per_second = {
                spores = spores > 0 and spores * i or nil,
                pollution = pollution * i,
            }
        end,

        --- Equipment
        ["active-defense-equipment"] = function(space, equipment)
        end,

        ["battery-equipment"] = function(space, equipment)
        end,

        ["roboport-equipment"] = function(space, equipment)
            equipment.robot_limit = space.amount * equipment.robot_limit
        end,

        ["generator-equipment"] = function(space, equipment)
        end,

        ["solar-panel-equipment"] = function(space, equipment)
            local Value, Unit = GMOD.number_unit(equipment.production)
            equipment.production = (space.amount * Value) .. Unit
        end,

        ["energy-shield-equipment"] = function(space, equipment)
        end,

        ["movement-bonus-equipment"] = function(space, equipment)
            equipment.movement_bonus = space.amount * equipment.movement_bonus
        end,
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

            if Space.entity.type == "accumulator" then
                if not Space.entity.energy_source then return end
                if not Space.entity.energy_source.output_flow_limit then return end
                local Energy = Space.entity.energy_source.output_flow_limit
                Energy = GMOD.number_unit(Energy)
                if not Energy then return end
            else
                if not This_MOD.effect_to_type[Space.entity.type] then return end
            end

            Space.localised_name = Space.entity.localised_name
            Space.localised_description = Space.entity.localised_description
        elseif Item.place_as_equipment_result then
            -- Space.equipment = GMOD.equipments[Item.place_as_equipment_result]
            return
        else
            return
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Belts = {
            ["underground-belt"] = true,
            ["lane-splitter"] = true,
            ["loader-1x1"] = true
        }

        repeat
            if not Belts[Space.entity.type] then break end
            if not Space.entity then break end

            local Find = Space.entity.type:gsub("%-", "%%-")
            local Belt = Space.item.name:gsub(Find, "transport-belt")
            Belt = GMOD.items[Belt]
            if not Belt then break end

            Space.belt = d12b.setting.amount
            if d12b.setting.stack_size then
                Space.belt = Space.belt * Belt.stack_size
                if Space.belt > 65000 then
                    Space.belt = 65000
                end
            end
        until true

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

        --- Cargar el objeto de referencia
        local Item = GMOD.items[entity]

        --- Nombre despues del aplicar el MOD
        local Name =
            GMOD.name .. (
                GMOD.get_id_and_name(space.name) or
                { ids = "-" }
            ).ids .. (
                d12b.setting.stack_size and
                Item.stack_size .. "x" .. d12b.setting.amount or
                space.amount
            ) .. "u-" .. (
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
