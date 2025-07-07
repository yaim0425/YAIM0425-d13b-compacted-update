---------------------------------------------------------------------------------------------------
---> data-final-fixes.lua <---
---------------------------------------------------------------------------------------------------

--- Contenedor de funciones y datos usados
--- unicamente en este archivo
local This_MOD = {}

---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
function This_MOD.start()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Obtener información del nombre de MOD
    GPrefix.split_name_folder(This_MOD)

    --- Valores de la referencia
    This_MOD.setting_mod()

    --- Darle un formato que facilite el manejor
    --- a lo largo de este mod
    This_MOD.set_format()

    --- Incluir las armas y las municiones
    This_MOD.order_guns_and_ammos()

    --- Filtrar los elementos a ordenar
    This_MOD.apply_filters()

    -- --- Corregir lo filtrado
    -- This_MOD.CorrectTaget()

    -- --- Eliminar los elementos duplicados - dejar el último
    -- This_MOD.OnlyLast()

    -- --- Separar los filtros grandes
    -- This_MOD.SplitBigTaget()

    -- --- Re-ordenar los subgroups
    -- This_MOD.SortSubgroups()

    -- --- Re-ordenar los objetivos
    -- This_MOD.SortTarget()

    -- --- Hacer algunas correciones
    -- This_MOD.Correct()

    -- --- Agrupar las recetas
    -- This_MOD.GroupRecipes()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Valores de la referencia
function This_MOD.setting_mod()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nueva organización según cada grupo
    This_MOD.new_order = {}
    This_MOD.new_order["logistics"] = {
        ["storages"] = {
            { type = "container", pattern = "chest" }
        },
        ["belts"] = {
            { type = "transport-belt", pattern = "transport-belt" }
        },
        ["underground-belts"] = {
            { type = "underground-belt", pattern = "underground-belt" }
        },
        ["splitters"] = {
            { type = "splitter", pattern = "splitter" }
        },
        ["inserters"] = {
            { type = "inserter", pattern = "inserter" }
        },
        ["container-1x1"] = {
            { type = "container",          pattern = "steel-chest" },

            { type = "logistic-container", pattern = "storage-chest" },
            { type = "logistic-container", pattern = "passive-provider-chest" },
            { type = "logistic-container", pattern = "requester-chest" },
            { type = "logistic-container", pattern = "buffer-chest" },
            { type = "logistic-container", pattern = "active-provider-chest" }
        },
        ["container-2x2"] = {
            { type = "container",          pattern = "strongbox" },

            { type = "logistic-container", pattern = "strongbox-storage" },
            { type = "logistic-container", pattern = "strongbox-passive-provider" },
            { type = "logistic-container", pattern = "strongbox-requester" },
            { type = "logistic-container", pattern = "strongbox-buffer" },
            { type = "logistic-container", pattern = "strongbox-active-provider" },

            { type = "logistic-container", pattern = "storage-strongbox" },
            { type = "logistic-container", pattern = "passive-provider-strongbox" },
            { type = "logistic-container", pattern = "requester-strongbox" },
            { type = "logistic-container", pattern = "buffer-strongbox" },
            { type = "logistic-container", pattern = "active-provider-strongbox" }
        },
        ["container-4x4"] = {
            { type = "container",          pattern = "storehouse" },

            { type = "logistic-container", pattern = "storehouse-storage" },
            { type = "logistic-container", pattern = "storehouse-passive-provider" },
            { type = "logistic-container", pattern = "storehouse-requester" },
            { type = "logistic-container", pattern = "storehouse-buffer" },
            { type = "logistic-container", pattern = "storehouse-active-provider" }
        },
        ["container-6x6"] = {
            { type = "container",          pattern = "warehouse" },

            { type = "logistic-container", pattern = "warehouse-storage" },
            { type = "logistic-container", pattern = "warehouse-passive-provider" },
            { type = "logistic-container", pattern = "warehouse-requester" },
            { type = "logistic-container", pattern = "warehouse-buffer" },
            { type = "logistic-container", pattern = "warehouse-active-provider" },

            { type = "logistic-container", pattern = "storage-warehouse" },
            { type = "logistic-container", pattern = "passive-provider-warehouse" },
            { type = "logistic-container", pattern = "requester-warehouse" },
            { type = "logistic-container", pattern = "buffer-warehouse" },
            { type = "logistic-container", pattern = "active-provider-warehouse" }
        },
        ["electric-system"] = {
            { type = "electric-pole", pattern = "electric-pole" },
            { type = "electric-pole", pattern = "substation" }
        },
        ["fluid-system"] = {
            { type = "pipe",           pattern = "pipe" },
            { type = "pipe-to-ground", pattern = "pipe-to-ground" },
            { type = "storage-tank",   pattern = "micro-tank" },
            { type = "storage-tank",   pattern = "storage-tank" },
            { type = "pump",           pattern = "pump" }
        },
        ["railways"] = {
            { type = "straight-rail",     pattern = "straight-rail" },
            { type = "rail-ramp",         pattern = "rail-ramp" },
            { type = "rail-support",      pattern = "rail-support" },
            { type = "train-stop",        pattern = "train-stop" },
            { type = "rail-signal",       pattern = "rail-signal" },
            { type = "rail-chain-signal", pattern = "rail-chain-signal" }
        },
        ["locomotive-wagon"] = {
            { type = "locomotive",      pattern = "locomotive" },
            { type = "cargo-wagon",     pattern = "cargo-wagon" },
            { type = "fluid-wagon",     pattern = "fluid-wagon" },
            { type = "artillery-wagon", pattern = "artillery-wagon" }
        },
        ["transports"] = {
            { type = "car",            pattern = "car" },
            { type = "car",            pattern = "tank" },
            { type = "spider-vehicle", pattern = "spidertron" },
        },
        ["logistic-network"] = {
            { type = "roboport",           pattern = "roboport" },
            { type = "logistic-robot",     pattern = "logistic-robot" },
            { type = "construction-robot", pattern = "construction-robot" }
        },
        ["circuit-network"] = {
            { type = "lamp",                  pattern = "small-lamp" },
            { type = "arithmetic-combinator", pattern = "arithmetic-combinator" },
            { type = "decider-combinator",    pattern = "decider-combinator" },
            { type = "selector-combinator",   pattern = "selector-combinator" },
            { type = "constant-combinator",   pattern = "constant-combinator" },
            { type = "power-switch",          pattern = "power-switch" },
            { type = "programmable-speaker",  pattern = "programmable-speaker" },
            { type = "display-panel",         pattern = "display-panel" }
        },
        ["terrain-vanilla"] = {
            { type = "tile", pattern = "stone-path" },
            { type = "tile", pattern = "concrete" },
            { type = "tile", pattern = "hazard-concrete" },
            { type = "tile", pattern = "refined-concrete" },
            { type = "tile", pattern = "refined-hazard-concrete" }
        },
        ["terrain-age"] = {
            { type = "capsule", pattern = "cliff-explosives" },
            { type = "tile",    pattern = "landfill" },
            { type = "tile",    pattern = "artificial-yumako-soil" },
            { type = "tile",    pattern = "overgrowth-yumako-soil" },
            { type = "tile",    pattern = "artificial-jellynut-soil" },
            { type = "tile",    pattern = "overgrowth-jellynut-soil" },
            { type = "tile",    pattern = "ice-platform" },
            { type = "tile",    pattern = "foundation" }
        }
    }
    This_MOD.new_order["production"] = {
        ["repair-tool"] = {
            { type = "repair-tool", pattern = "repair-pack" }
        },
        ["steam-system"] = {
            { type = "boiler",    name = "boiler" },
            { type = "generator", pattern = "steam-engine" }
        },
        ["solar-system"] = {
            { type = "solar-panel", pattern = "." },
            { type = "accumulator", pattern = "accumulator" }
        },
        ["nucleare-system"] = {
            { type = "reactor",   pattern = "nuclear-reactor" },
            { type = "heat-pipe", pattern = "heat-pipe" },
            { type = "boiler",    pattern = "heat-exchanger" },
            { type = "generator", pattern = "steam-turbine" }
        },
        ["fusion-system"] = {
            { type = "fusion-reactor",   pattern = "fusion-reactor" },
            { type = "fusion-generator", pattern = "fusion-generator" }
        },
        ["lightning-attractor"] = {
            { type = "lightning-attractor", pattern = "lightning-rod" },
            { type = "lightning-attractor", pattern = "lightning-collector" }
        },
        ["mining-drills"] = {
            { type = "mining-drill", pattern = "-drill" },
            -- { type = "mining-drill", pattern = "mining-drill" },
            { type = "mining-drill", pattern = "micro-miner" }
        },
        ["liquids-extractor"] = {
            { type = "offshore-pump", pattern = "offshore-pump" },
            { type = "mining-drill",  pattern = "pumpjack" }
        },
        ["furnaces"] = {
            { type = "furnace", pattern = "furnace" }
        },
        ["varied-production"] = {
            { type = "furnace",            pattern = "recycler" },
            { type = "reactor",            pattern = "heating-tower" },
            { type = "assembling-machine", pattern = "foundry" },
            { type = "agricultural-tower", pattern = "agricultural-tower" },
            { type = "assembling-machine", pattern = "biochamber" },
            { type = "assembling-machine", pattern = "captive-biter-spawner" },
            { type = "assembling-machine", pattern = "cryogenic-plant" }
        },
        ["assembling-machines"] = {
            { type = "assembling-machine", pattern = "assembling-machine" },
            { type = "assembling-machine", pattern = "electromagnetic-plant" },
            { type = "assembling-machine", pattern = "micro-assembler" }
        },
        ["other-machines"] = {
            { type = "assembling-machine", pattern = "oil-refinery" },
            { type = "assembling-machine", pattern = "chemical-plant" },
            { type = "assembling-machine", pattern = "centrifuge" },
            { type = "assembling-machine", pattern = "micro-chemplant" }
        },
        ["labs"] = {
            { type = "beacon", pattern = "beacon" },
            { type = "lab",    pattern = "lab" },
            { type = "lab",    pattern = "biolab" }
        },
        ["speed-modules"] = {
            { type = "module", pattern = "speed-module" }
        },
        ["efficiency-modules"] = {
            { type = "module", pattern = "efficiency-module" }
        },
        ["productivity-modules"] = {
            { type = "module", pattern = "productivity-module" }
        },
        ["quality-modules"] = {
            { type = "module", pattern = "quality-module" }
        },
        ["space"] = {
            { type = "cargo-landing-pad", pattern = "cargo-landing-pad" },
            { type = "rocket-silo",       pattern = "rocket-silo" },
            { type = "item",              pattern = "satellite" }
        }
    }
    This_MOD.new_order["intermediate-products"] = {
        ["recipes-crude-oil"] = {
            { type = "recipe", name = "basic-oil-processing" },
            { type = "recipe", name = "advanced-oil-processing" },
            { type = "recipe", name = "coal-liquefaction" },
            { type = "recipe", name = "heavy-oil-cracking" },
            { type = "recipe", name = "light-oil-cracking" },
            { type = "recipe", name = "lubricant" },
            { type = "recipe", name = "sulfuric-acid" }
        },
        ["raw-resource"] = {
            { type = "item",    name = "wood" },
            { type = "item",    name = "coal" },
            { type = "item",    name = "stone" },
            { type = "item",    name = "iron-ore" },
            { type = "item",    name = "copper-ore" },
            { type = "item",    name = "uranium-ore" },
            { type = "capsule", name = "raw-fish" },
            { type = "item",    name = "ice" }
        },
        ["raw-material"] = {
            { type = "item", name = "iron-plate" },
            { type = "item", name = "copper-plate" },
            { type = "item", name = "steel-plate" },
            { type = "item", name = "solid-fuel" },
            { type = "item", name = "plastic-bar" },
            { type = "item", name = "sulfur" },
            { type = "item", name = "battery" },
            { type = "item", name = "explosives" },
            { type = "item", name = "carbon" }
        },
        ["recipes-empty-barrels"] = {
            { type = "recipe", pattern = "empty-" }
        },
        ["barrels"] = {
            { type = "item", pattern = "-barrel" }
        },
        ["products"] = {
            { type = "item", name = "iron-gear-wheel" },
            { type = "item", name = "iron-stick" },
            { type = "item", name = "copper-cable" },
            { type = "item", name = "barrel" },
            { type = "item", name = "low-density-structure" },
            { type = "item", name = "rocket-fuel" }
        },
        ["circuits"] = {
            { type = "item", name = "electronic-circuit" },
            { type = "item", name = "advanced-circuit" },
            { type = "item", name = "processing-unit" },
        },
        ["engines"] = {
            { type = "item", name = "engine-unit" },
            { type = "item", name = "electric-engine-unit" },
            { type = "item", name = "flying-robot-frame" },
        },
        ["uranium"] = {
            { type = "item",   name = "uranium-235" },
            { type = "item",   name = "uranium-238" },
            { type = "item",   name = "uranium-fuel-cell" },
            { type = "item",   name = "depleted-uranium-fuel-cell" },
            { type = "item",   name = "nuclear-fuel" },
            { type = "recipe", name = "nuclear-fuel-reprocessing" },
            { type = "recipe", name = "uranium-processing" },
            { type = "recipe", name = "kovarex-enrichment-process" }
        },
        ["vulcanus"] = {
            { type = "item", name = "calcite" },
            { type = "item", name = "tungsten-ore" },
            { type = "item", name = "tungsten-carbide" },
            { type = "item", name = "tungsten-plate" }
        },
        ["fulgora"] = {
            { type = "item", name = "holmium-ore" },
            { type = "item", name = "holmium-plate" },
            { type = "item", name = "superconductor" },
            { type = "item", name = "supercapacitor" }
        },
        ["gleba-agriculture"] = {
            { type = "item", name = "yumako-seed" },
            { type = "item", name = "jellynut-seed" },
            { type = "item", name = "tree-seed" },
            { type = "item", name = "yumako" },
            { type = "item", name = "jellynut" },
            { type = "item", name = "iron-bacteria" },
            { type = "item", name = "copper-bacteria" },
            { type = "item", name = "spoilage" },
            { type = "item", name = "nutrients" }
        },
        ["gleba"] = {
            { type = "item", name = "bioflux" },
            { type = "item", name = "yumako-mash" },
            { type = "item", name = "jelly" },
            { type = "item", name = "carbon-fiber" },
            { type = "item", name = "biter-egg" },
            { type = "item", name = "pentapod-egg" }
        },
        ["aquilo"] = {
            { type = "item", name = "lithium" },
            { type = "item", name = "lithium-plate" },
            { type = "item", name = "quantum-processor" },
            { type = "item", name = "fusion-power-cell" }
        },
        ["science-pack-othres"] = {
            { type = "tool", pattern = "-science-pack" }
        },
        ["science-pack-vanilla"] = {
            { type = "tool", pattern = "automation-science-pack" },
            { type = "tool", pattern = "logistic-science-pack" },
            { type = "tool", pattern = "military-science-pack" },
            { type = "tool", pattern = "chemical-science-pack" },
            { type = "tool", pattern = "production-science-pack" },
            { type = "tool", pattern = "utility-science-pack" },
            { type = "tool", pattern = "space-science-pack" }
        },
        ["science-pack-space-age"] = {
            { type = "tool", pattern = "metallurgic-science-pack" },
            { type = "tool", pattern = "electromagnetic-science-pack" },
            { type = "tool", pattern = "agricultural-science-pack" },
            { type = "tool", pattern = "cryogenic-science-pack" },
            { type = "tool", pattern = "promethium-science-pack" }
        }
    }
    This_MOD.new_order["combat"] = {
        ["entity"] = {
            { type = "fluid-turret",    pattern = "." },
            { type = "electric-turret", pattern = "." },
            { type = "gate",            pattern = "." },
            { type = "wall",            pattern = "." },
            { type = "land-mine",       pattern = "." },
            { type = "radar",           pattern = "." }
        },
        ["capsules"] = {
            { type = "capsule", pattern = "grenade" },
            { type = "capsule", pattern = "-capsule" }
        },
        ["armors"] = {
            { type = "armor", pattern = "." }
        },
        ["energy-equipments"] = {
            { type = "solar-panel-equipment", pattern = "." },
            { type = "generator-equipment",   pattern = "." },
            { type = "battery-equipment",     pattern = "." }
        },
        ["other-equipments"] = {
            { type = "belt-immunity-equipment",   pattern = "." },
            { type = "movement-bonus-equipment",  pattern = "." },
            { type = "roboport-equipment",        pattern = "." },
            { type = "night-vision-equipment",    pattern = "." },
            { type = "inventory-bonus-equipment", pattern = "." }
        },
        ["combat-equipments"] = {
            { type = "energy-shield-equipment",  pattern = "." },
            { type = "active-defense-equipment", pattern = "." },
            { type = "active-defense-equipment", pattern = "." }
        }
    }
    This_MOD.new_order["fluids"] = {
        ["vanilla"] = {
            { type = "fluid", name = "water" },
            { type = "fluid", name = "steam" },
            { type = "fluid", name = "crude-oil" },
            { type = "fluid", name = "heavy-oil" },
            { type = "fluid", name = "light-oil" },
            { type = "fluid", name = "lubricant" },
            { type = "fluid", name = "petroleum-gas" },
            { type = "fluid", name = "sulfuric-acid" }
        },
        ["spaceship"] = {
            { type = "fluid", name = "thruster-fuel" },
            { type = "fluid", name = "thruster-oxidizer" }
        },
        ["vulcanus"] = {
            { type = "fluid", name = "lava" },
            { type = "fluid", name = "molten-iron" },
            { type = "fluid", name = "molten-copper" }
        },
        ["fulgora"] = {
            { type = "fluid", name = "holmium-solution" },
            { type = "fluid", name = "electrolyte" }
        },
        ["aquilo"] = {
            { type = "fluid", name = "ammoniacal-solution" },
            { type = "fluid", name = "ammonia" },
            { type = "fluid", name = "fluorine" },
            { type = "fluid", name = "fluoroketone-hot" },
            { type = "fluid", name = "fluoroketone-cold" },
            { type = "fluid", name = "lithium-brine" },
            { type = "fluid", name = "fusion-plasma" }
        }
    }

    --- Fusionar los resultados de los filtros
    This_MOD.fusion = {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Eliminar los subgroup vacios
function This_MOD.delete_empty_subgroups()
    --- Eliminar los subgroup vacios
    for _, groups in pairs(This_MOD.new_order) do
        local Remove = {}

        --- Buscar los vacios
        for key, subgroup in pairs(groups) do
            if GPrefix.get_length(subgroup) == 0 then
                Remove[key] = true
            end
        end

        --- Borrar los vacios
        for key, _ in pairs(Remove) do
            groups[key] = nil
        end
    end
end

---------------------------------------------------------------------------------------------------

--- Darle un formato que facilite el manejor
--- a lo largo de este mod
function This_MOD.set_format()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.after_format = {}
    for group_name, subgroups in pairs(This_MOD.new_order) do
        --- --- --- --- --- --- --- --- --- --- --- --- ---
        local Space = { name = group_name }
        table.insert(This_MOD.after_format, Space)
        --- --- --- --- --- --- --- --- --- --- --- --- ---
        for subgroup_name, subgroup in pairs(subgroups) do
            subgroup = util.copy(subgroup)
            table.insert(Space, subgroup)
            subgroup.name = subgroup_name
        end
        --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Incluir las armas y las municiones
function This_MOD.order_guns_and_ammos()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Municiones y armas
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Filtrar las municiones
    local Ammos_by_type = {}
    for _, ammo in pairs(data.raw["ammo"]) do
        local Type = Ammos_by_type[ammo.ammo_category] or {}
        Ammos_by_type[ammo.ammo_category] = Type
        table.insert(Type, ammo)
    end

    --- Filtrar las armas
    local Guns_by_type = {}
    for _, gun in pairs(GPrefix.Items) do
        local ammo = gun.attack_parameters and gun.attack_parameters.ammo_category or nil
        if ammo then
            local type = Guns_by_type[ammo] or {}
            Guns_by_type[ammo] = type
            table.insert(type, gun)
        end
    end

    --- Combinar armas y municiones, si es posible
    local Ammos = {}          --- Municiones sin armas
    local Guns_and_ammos = {} --- Municiones con armas
    for ammo_category, type in pairs(Ammos_by_type) do
        --- Municiones con armas
        if Guns_by_type[ammo_category] then
            --- Crear el espacio
            local subgroup = Guns_and_ammos[ammo_category] or {}
            Guns_and_ammos[ammo_category] = subgroup

            --- Agregar las armas
            for _, weapon in pairs(Guns_by_type[ammo_category]) do
                table.insert(subgroup, { type = weapon.type, name = weapon.name })
            end

            --- Agregar las municiones
            for _, ammo in pairs(type) do
                table.insert(subgroup, { type = ammo.type, name = ammo.name })
            end
        end

        --- Municiones sin armas
        if not Guns_by_type[ammo_category] then
            for _, ammo in pairs(type) do
                table.insert(Ammos, { type = ammo.type, name = ammo.name })
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Agregar municiones y entidades
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Agregar la ametralladora
    for _, entity in pairs(data.raw["ammo-turret"]) do
        if entity.minable then
            table.insert(Guns_and_ammos['bullet'], {
                pattern = entity.name,
                type = entity.type
            })
        end
    end

    --- Agregar la artilleria
    Guns_and_ammos['artillery'] = {}
    for _, Entity in pairs(data.raw["artillery-turret"]) do
        if Entity.minable then
            table.insert(Guns_and_ammos['artillery'], {
                pattern = Entity.name,
                type = Entity.type
            })
        end
    end

    --- Agregar la municiones para la artilleria
    for i = #Ammos, 1, -1 do
        if string.find(Ammos[i].name, "artillery") then
            table.insert(Guns_and_ammos['artillery'], Ammos[i])
            table.remove(Ammos, i)
        end
    end


    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Agregar los nuevos filtros
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Combat = GPrefix.get_table(This_MOD.after_format, "name", "combat")
    local Count = #Combat - 2 -- 2 Posicion del primer subgroup
    for key, value in pairs(Guns_and_ammos) do
        value.name = key
        table.insert(Combat, #Combat - Count, value)
    end
    Ammos.name = "other-ammo"
    table.insert(Combat, #Combat - Count, Ammos)

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Filtrar los elementos a ordenar
function This_MOD.apply_filters()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Contiene el resultado de los filtros
    This_MOD.new_order = {}

    --- Aplicar los filtros
    for i = #This_MOD.after_format, 1, -1 do
        local After_subgroups = This_MOD.after_format[i] or {}
        local New_subgroups = This_MOD.new_order[i] or {}
        This_MOD.new_order[i] = New_subgroups
        New_subgroups.name = After_subgroups.name
        for j = #After_subgroups, 1, -1 do
            local After_subgroup = After_subgroups[j] or {}
            local New_subgroup = New_subgroups[j] or {}
            New_subgroups[j] = New_subgroup
            New_subgroup.name = After_subgroup.name
            for k = #After_subgroup, 1, -1 do
                local After_filter = After_subgroup[k] or {}
                local New_filter = New_subgroup[k] or {}
                New_subgroup[k] = New_filter
                --- --- --- --- --- --- --- --- --- --- ---

                --- Filtro a usar
                local Pattern = After_filter.pattern and string.gsub(After_filter.pattern, "-", "%%-") or nil
                local Name = After_filter.name

                --- Recorrer los elementos
                for _, elemet in pairs(data.raw[After_filter.type] or {}) do
                    if not elemet.hidden then
                        if Pattern then
                            --- Filtrar por patron
                            if Pattern ~= "." and string.find(elemet.name, Pattern) then
                                table.insert(New_filter, elemet)
                            end
                            --- Todo es valido
                            if Pattern == "." then
                                table.insert(New_filter, elemet)
                            end
                        end

                        --- Filtrar por nombre
                        if not Pattern then
                            if elemet.name == Name then
                                table.insert(New_filter, elemet)
                            end
                        end
                    end
                end

                --- --- --- --- --- --- --- --- --- --- ---

                --- Eliminar los filtros vacios
                if #New_filter == 0 then
                    New_subgroup[k] = nil
                end
            end

            --- Eliminar los subgrupos vacios
            if #New_subgroup == 0 then
                New_subgroups[j] = nil
            end
        end
    end

    --- Remplazar entidades por los objetos
    for i = #This_MOD.new_order, 1, -1 do
        local Subgroups = This_MOD.new_order[i] or {}
        for j = #Subgroups, 1, -1 do
            local Subgroup = Subgroups[j] or {}
            for k = #Subgroup, 1, -1 do
                local Filter = Subgroup[k] or {}
                for l = #Filter, 1, -1 do
                    local Element = Filter[l]
                    --- --- --- --- --- --- --- --- --- --- ---

                    --- Indicadores de busqueda
                    local Items = nil

                    --- Buscar elementos
                    if Element.minable and Element.minable.results then
                        Items = Element.minable.results
                    elseif GPrefix.Equipments[Element.name] then
                        Items = { Element }
                    end

                    --- Acción a tomar
                    for _, Item in pairs(Items or {}) do
                        local Item = GPrefix.Items[Item.name]
                        if Item then table.insert(Filter, Item) end
                    end

                    --- --- --- --- --- --- --- --- --- --- ---
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

--- Corregir lo filtrado
function This_MOD.CorrectTaget()
    --- Enlistar los subgroups a corregir
    local listKeys = {
        { "logistics", "electric-system" },
        { "combat",    "capsules" }
    }

    --- Hacer la corrección
    for _, keys in pairs(listKeys) do
        --- Subgroup a corregir
        local Aux = This_MOD.new_order
        for _, key in pairs(keys) do
            Aux = Aux[key] or {}
        end

        --- Validación
        if #Aux < 2 then Aux = {} end

        --- Mover de filtro
        Count = #Aux
        for _ = 2, Count, 1 do
            for _, element in pairs(Aux[2]) do
                table.insert(Aux[1], element)
            end
            table.remove(Aux, 2)
        end
    end
end

--- Eliminar los elementos duplicados - dejar el último
function This_MOD.OnlyLast()
    --- Reordenar para buscar
    local listSort = {}
    for SubgroupsKey, Subgroups in pairs(This_MOD.new_order) do
        for SubgroupKey, Subgroup in pairs(Subgroups) do
            for ElementsKey, Elements in pairs(Subgroup) do
                for ElementKey, Element in pairs(Elements) do
                    local Key = {
                        SubgroupsKey,
                        SubgroupKey,
                        ElementsKey,
                        ElementKey
                    }

                    table.insert(listSort, { keys = Key, value = Element })
                end
            end
        end
    end

    --- Elementos a eliminar
    local listDelete = { keys = {}, values = {} }

    --- Buscar duplicados
    Count = #listSort
    for i = 1, Count - 1, 1 do
        for j = i + 1, Count, 1 do
            local iElement = listSort[i]
            local jElement = listSort[j]
            if iElement.value == jElement.value then
                local keys = table.concat(iElement.keys, " > ")
                if not GPrefix.get_key(listDelete.keys, keys) then
                    listDelete.values[keys] = iElement.keys
                    table.insert(listDelete.keys, keys)
                end
            end
        end
    end

    --- Invertir el orden a eliminar
    for i = #listDelete.keys, 1, -1 do
        local key = listDelete.keys[i]
        local value = listDelete.values[key]
        table.insert(listDelete, value)
    end
    listDelete.values = nil
    listDelete.keys = nil

    --- Resultados afectados
    local listValidate = { keys = {} }

    --- Eliminar los duplicados
    for _, keys in pairs(listDelete) do
        local Aux = This_MOD.new_order
        for i = 1, 3, 1 do
            Aux = Aux[keys[i]]
        end
        table.remove(Aux, keys[4])

        table.remove(keys)
        local key = table.concat(keys, " > ")
        if not GPrefix.get_key(listValidate.keys, key) then
            table.insert(listValidate.keys, key)
            table.insert(listValidate, keys)
        end
    end
    listValidate.keys = nil

    --- Eliminar los resultados vacios
    for _, keys in pairs(listValidate) do
        local Aux = This_MOD.new_order
        for i = 1, 2, 1 do
            Aux = Aux[keys[i]]
        end

        if #Aux[keys[3]] == 0 then
            table.remove(Aux, keys[3])
        end
    end

    --- Eliminar los subgroup vacios
    This_MOD.delete_empty_subgroups()
end

--- Separar los filtros grandes
function This_MOD.SplitBigTaget()
    --- Reordenar para buscar
    local listSort = {}
    for SubgroupsKey, Subgroups in pairs(This_MOD.new_order) do
        for SubgroupKey, Subgroup in pairs(Subgroups) do
            for ElementsKey, Elements in pairs(Subgroup) do
                local Key = {
                    SubgroupsKey,
                    SubgroupKey,
                    ElementsKey
                }

                table.insert(listSort, { keys = Key, value = Elements })
            end
        end
    end

    --- Elimentos retirados
    local listValidate = {}

    --- Buscar en los resultados de los filtros
    Count = #listSort
    repeat
        --- Renombrar
        local Filtro = listSort[Count]
        local Aux = This_MOD.new_order
        Aux = Aux[Filtro.keys[1]]
        Aux = Aux[Filtro.keys[2]]

        --- Evaluar el tamaño
        if #Filtro.value > 2 and #Aux > 1 then
            --- Crear los contenedores
            local Group = listValidate[Filtro.keys[1]] or {}
            listValidate[Filtro.keys[1]] = Group

            local Subgroup = Group[Filtro.keys[2]] or {}
            Group[Filtro.keys[2]] = Subgroup

            --- Guardar el filtro
            table.insert(Subgroup, 1, Filtro.value)
            table.remove(Aux, Filtro.keys[3])
        end

        --- Continuar la evaluación
        Count = Count - 1
    until Count <= 0

    --- Agregar los nuevos subgroups
    for GroupName, Subgroups in pairs(listValidate) do
        local NewGroup = {}
        for key, value in pairs(This_MOD.new_order[GroupName]) do
            --- Posicionar los nuevos subgroups
            if Subgroups[key] then
                table.insert(NewGroup, { name = key .. "-1", value = value })
                for i = 1, #Subgroups[key], 1 do
                    table.insert(NewGroup, {
                        name = key .. "-" .. i + 1,
                        value = { Subgroups[key][i] }
                    })
                end
            end

            --- Subgroups sin cambios
            if not Subgroups[key] then
                table.insert(NewGroup, { name = key, value = value })
            end
        end

        --- Agregar los nuevos subgroups
        local newGroup = {}
        This_MOD.new_order[GroupName] = newGroup
        for _, Subgroup in pairs(NewGroup) do
            newGroup[Subgroup.name] = Subgroup.value
        end
    end

    --- Eliminar los subgroup vacios
    This_MOD.delete_empty_subgroups()
end

--- Re-ordenar los subgroups
function This_MOD.SortSubgroups()
    --- Agrupar los veijos subgroups
    local oldGroup = {}
    for group, _ in pairs(This_MOD.new_order) do
        local Group = oldGroup[group] or {}
        oldGroup[group] = Group
        for _, subgroup in pairs(data.raw["item-subgroup"]) do
            if subgroup.group == group then
                Group[tonumber(subgroup.order) / 10] = subgroup
            end
        end
    end

    --- Crear y agrupar los nuevos subgroups
    local newGroup = {}
    for group, subgroups in pairs(This_MOD.new_order) do
        local Group = newGroup[group] or {}
        newGroup[group] = Group
        for subgroup, _ in pairs(subgroups) do
            local newSubgroup = {
                type = "item-subgroup",
                group = group,
                order = #Group + 1 .. "",
                name = This_MOD.prefix .. subgroup
            }
            table.insert(Group, newSubgroup)
            GPrefix.addDataRaw({ newSubgroup })
        end
    end

    --- Reordenar los nuevos subgroups
    for group, subgroups in pairs(newGroup) do
        local Digits = #oldGroup[group]
        Digits = Digits + #newGroup[group]
        Digits = GPrefix.digit_count(Digits) + 1

        for key, subgroup in pairs(subgroups) do
            subgroup.order = GPrefix.pad_left(Digits, key) .. "0"
        end
    end

    --- Reordenar los viejos subgroups
    for group, subgroups in pairs(oldGroup) do
        local Digits = #oldGroup[group]
        Digits = Digits + #newGroup[group]
        Digits = GPrefix.digit_count(Digits) + 1

        Count = #newGroup[group]

        for key, subgroup in pairs(subgroups) do
            subgroup.order = GPrefix.pad_left(Digits, Count + key) .. "0"
        end
    end
end

--- Re-ordenar los objetivos
function This_MOD.SortTarget()
    --- Cambiar los orders para ordenarlo luego
    for _, Subgroups in pairs(This_MOD.new_order) do
        for _, Subgroup in pairs(Subgroups) do
            for i, Elements in pairs(Subgroup) do
                for _, Element in pairs(Elements) do
                    if Element.subgroup then
                        Element.order = Element.order or ""
                        local newOrder = Element.subgroup
                        newOrder = This_MOD.subgroups[newOrder].order
                        newOrder = newOrder .. "-"
                        newOrder = newOrder .. GPrefix.pad_left(2, i) .. "-"
                        newOrder = newOrder .. Element.order
                        Element.order = newOrder
                    end
                end
            end
        end
    end

    --- Ordenar los elementos
    for _, Subgroups in pairs(This_MOD.new_order) do
        for Name, Elements in pairs(Subgroups) do
            --- Contenedor temporal
            local NewOrder = {}
            local NewSort = {}

            --- Obtener los orders
            for _, Subgroup in pairs(Elements) do
                for _, Element in pairs(Subgroup) do
                    if Element.subgroup then
                        NewSort[Element.order] = Element
                        table.insert(NewOrder, Element.order)
                    end
                end
            end

            --- Ordenar
            table.sort(NewOrder)

            --- Establecer el nuevo order
            local newSubgroup = {}
            Subgroups[Name] = newSubgroup
            for _, order in pairs(NewOrder) do
                table.insert(newSubgroup, NewSort[order])
            end
        end
    end

    --- Actualizar el order
    for _, subgroups in pairs(This_MOD.new_order) do
        for subgroup, elements in pairs(subgroups) do
            local Digits = GPrefix.digit_count(#elements) + 1
            for key, element in pairs(elements) do
                element.subgroup = This_MOD.prefix .. subgroup
                element.order = GPrefix.pad_left(Digits, key) .. "0"
            end
        end
    end
end

--- Hacer algunas correciones
function This_MOD.Correct()
    --- Ocultar las recetas para vaciar los barriles
    local RecipesEmptyBarrels = This_MOD.new_order["intermediate-products"]
    RecipesEmptyBarrels = RecipesEmptyBarrels["recipes-empty-barrels"]
    for _, Recipe in pairs(RecipesEmptyBarrels) do
        Recipe.subgroup = This_MOD.subgroup
        Recipe.allow_decomposition = false
        Recipe.hide_from_signal_gui = false
        Recipe.hide_from_player_crafting = true
        Recipe.factoriopedia_alternative = 'barrel'
    end

    --- Eliminar subgroup y order
    for _, Entity in pairs(data.raw['combat-robot']) do
        Entity.subgroup = nil
        Entity.order = nil
    end
end

--- Agrupar las recetas
function This_MOD.GroupRecipes()
    for Name, Recipes in pairs(GPrefix.Recipes) do
        local Item = GPrefix.Items[Name]
        if Item then
            Item.order = Item.order or "0"
            local NewOrder = tonumber(Item.order) or 0
            for _, Recipe in pairs(Recipes) do
                if #Recipe.results == 1 then
                    Recipe.subgroup = Item.subgroup
                    Recipe.order    = GPrefix.pad_left(#Item.order, NewOrder)
                    NewOrder        = NewOrder + 1
                end
            end
        end
    end
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
This_MOD.start()
-- GPrefix.var_dump(This_MOD.new_order)
ERROR()

---------------------------------------------------------------------------------------------------
