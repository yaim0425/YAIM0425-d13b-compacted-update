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

    --- Fusionar los resiltados de los filtros indicados
    This_MOD.join_filters()

    --- Eliminar los elementos duplicados - dejar el último
    This_MOD.only_last()

    --- Separar los filtros grandes
    This_MOD.split_big_taget()

    --- Re-ordenar los subgroups
    This_MOD.sort_subgroups()

    --- Re-ordenar los objetivos
    This_MOD.sort_items()

    --- Hacer algunas correciones
    This_MOD.correct()

    --- Agrupar las recetas
    This_MOD.closer_together()

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
        ["pus-container-2x2"] = {
            { type = "container",          pattern = "storage-hut" },
            { type = "logistic-container", pattern = "logistic-storage-hut" },
            { type = "logistic-container", pattern = "logistic-passive-provider-hut" },
            { type = "logistic-container", pattern = "logistic-requester-hut" },
            { type = "logistic-container", pattern = "logistic-buffer-hut" },
            { type = "logistic-container", pattern = "logistic-active-provider-hut" }
        },
        ["aai-container-2x2"] = {
            { type = "container",          name = "aai-strongbox" },
            { type = "logistic-container", name = "aai-strongbox-storage" },
            { type = "logistic-container", name = "aai-strongbox-passive-provider" },
            { type = "logistic-container", name = "aai-strongbox-requester" },
            { type = "logistic-container", name = "aai-strongbox-buffer" },
            { type = "logistic-container", name = "aai-strongbox-active-provider" }
        },
        ["aai-container-4x4"] = {
            { type = "container",          name = "aai-storehouse" },
            { type = "logistic-container", name = "aai-storehouse-storage" },
            { type = "logistic-container", name = "aai-storehouse-passive-provider" },
            { type = "logistic-container", name = "aai-storehouse-requester" },
            { type = "logistic-container", name = "aai-storehouse-buffer" },
            { type = "logistic-container", name = "aai-storehouse-active-provider" }
        },
        ["pus-container-5x5"] = {
            { type = "container",          name = "warehouse" },
            { type = "logistic-container", name = "logistic-warehouse" },
            { type = "logistic-container", name = "logistic-warehouse-passive-provider" },
            { type = "logistic-container", name = "logistic-warehouse-requester" },
            { type = "logistic-container", name = "logistic-warehouse-buffer" },
            { type = "logistic-container", name = "logistic-warehouse-active-provider" }
        },
        ["aai-container-6x6"] = {
            { type = "container",          name = "aai-warehouse" },
            { type = "logistic-container", name = "aai-warehouse-storage" },
            { type = "logistic-container", name = "aai-warehouse-passive-provider" },
            { type = "logistic-container", name = "aai-warehouse-requester" },
            { type = "logistic-container", name = "aai-warehouse-buffer" },
            { type = "logistic-container", name = "aai-warehouse-active-provider" }
        },
        ["electric-system"] = {
            { type = "electric-pole", pattern = "electric-pole" },
            { type = "electric-pole", pattern = "substation" },
            { type = "electric-pole", name = "electrical-distributor" }
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
            { type = "lamp",                  pattern = "-lamp" },
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
        ["aid-kit"] = {
            { type = "capsule", pattern = "aid-kit" },
        },
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
            { type = "capsule", name = "raw-fish" }
        },
        ["kr-raw-resource"] = {
            { type = "item", name = "kr-sand" },
            { type = "item", name = "kr-imersite" },
            { type = "item", name = "kr-rare-metal-ore" }
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
            { type = "item", name = "carbon" },
        },
        ["kr-raw-material"] = {
            { type = "item", name = "kr-coke" },
            { type = "item", name = "kr-glass" },
            { type = "item", name = "kr-fertilizer" },
            { type = "item", name = "kr-biomass" },
            { type = "item", name = "kr-quartz" },
            { type = "item", name = "kr-silicon" },
            { type = "item", name = "kr-rare-metals" },
            { type = "item", name = "kr-imersium-plate" },
            { type = "item", name = "kr-lithium-chloride" },
            { type = "item", name = "kr-lithium" },
            { type = "item", name = "kr-lithium-sulfur-battery" },
            { type = "item", name = "kr-imersite-powder" },
            { type = "item", name = "kr-tritium" }
        },
        ["kr-enriched"] = {
            { type = "item",   name = "kr-enriched-iron" },
            { type = "item",   name = "kr-enriched-copper" },
            { type = "item",   name = "kr-enriched-rare-metals" },
            { type = "recipe", name = "kr-enriched-iron" },
            { type = "recipe", name = "kr-enriched-copper" },
            { type = "recipe", name = "kr-enriched-rare-metals" }
        },
        ["kr-fluids"] = {
            { type = "recipe", name = "kr-water-from-atmosphere" },
            { type = "recipe", name = "kr-filter-iron-ore-from-dirty-water" },
            { type = "recipe", name = "kr-filter-copper-ore-from-dirty-water" },
            { type = "recipe", name = "kr-filter-rare-metal-ore-from-dirty-water" },
            { type = "recipe", name = "kr-coal-filtration" }
        },
        ["kr-fuel"] = {
            { type = "item", name = "kr-fuel" },
            { type = "item", name = "kr-biofuel" },
            { type = "item", name = "kr-advanced-fuel" }
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
        ["kr-matter-to"] = {
            { type = "recipe", pattern = "kr-matter-to-" }
        },
        ["-to-matter"] = {
            { type = "recipe", pattern = "-to-matter" }
        },
        ["kr-electric-components"] = {
            { type = "item", pattern = "kr-inserter-part" },
            { type = "item", pattern = "kr-electronic-components" }
        },
        ["kr-crush"] = {
            { type = "recipe", pattern = "kr-crush-" }
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
        ["kr-to-lab"] = {
            { type = "item", pattern = "-tech-card" },
            { type = "item", pattern = "-research-data" },
            { type = "tool", pattern = "-tech-card" }
        },
        ["science-pack-vanilla"] = {
            { type = "tool", name = "automation-science-pack" },
            { type = "tool", name = "logistic-science-pack" },
            { type = "tool", name = "military-science-pack" },
            { type = "tool", name = "chemical-science-pack" },
            { type = "tool", name = "production-science-pack" },
            { type = "tool", name = "utility-science-pack" },
            { type = "tool", name = "space-science-pack" }
        },
        ["science-pack-space-age"] = {
            { type = "tool", name = "metallurgic-science-pack" },
            { type = "tool", name = "electromagnetic-science-pack" },
            { type = "tool", name = "agricultural-science-pack" },
            { type = "tool", name = "cryogenic-science-pack" },
            { type = "tool", name = "promethium-science-pack" }
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
    This_MOD.new_order["enemies"] = {
        ["biter"] = {
            { type = "unit", pattern = "-biter" }
        },
        ["spitter"] = {
            { type = "unit", pattern = "-spitter" }
        },
        ["worm"] = {
            { type = "turret", pattern = "-worm-turret" }
        },
        ["spawner"] = {
            { type = "unit-spawner", pattern = "-spawner" }
        },
    }

    --- Fusionar los resultados de los filtros
    This_MOD.join = {
        {
            group = "logistics",
            subgroup = "electric-system",
            filters = { 1, 2 }
        },
        {
            group = "combat",
            subgroup = "capsules",
            filters = { 1, 2 }
        }
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





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
    for i = 1, #This_MOD.after_format, 1 do
        local After_group = This_MOD.after_format[i]
        local New_group = { name = After_group.name }
        table.insert(This_MOD.new_order, New_group)
        for j = 1, #After_group, 1 do
            local After_subgroup = After_group[j]
            local New_subgroup = { name = After_subgroup.name }
            for k = 1, #After_subgroup, 1 do
                local Filter = After_subgroup[k]
                local Results = {}
                --- --- --- --- --- --- --- --- --- --- ---

                --- Filtro a usar
                local Pattern = Filter.pattern and string.gsub(Filter.pattern, "-", "%%-") or nil
                local Name = Filter.name

                --- Recorrer los elementos
                for _, elemet in pairs(data.raw[Filter.type] or {}) do
                    if not elemet.hidden then
                        if Pattern then
                            --- Filtrar por patron
                            if Pattern ~= "." and string.find(elemet.name, Pattern) then
                                table.insert(Results, elemet)
                            end
                            --- Todo es valido
                            if Pattern == "." then
                                table.insert(Results, elemet)
                            end
                        end

                        --- Filtrar por nombre
                        if not Pattern then
                            if elemet.name == Name then
                                table.insert(Results, elemet)
                            end
                        end
                    end
                end

                --- --- --- --- --- --- --- --- --- --- ---

                --- Agregar resultados
                if #Results > 0 then
                    table.insert(New_subgroup, Results)
                end
            end

            --- Agregar los subgroup
            if #New_subgroup > 0 then
                table.insert(New_group, New_subgroup)
            end
        end
    end

    --- Remplazar entidades por los objetos
    for i = #This_MOD.new_order, 1, -1 do
        local Subgroups = This_MOD.new_order[i]
        for j = #Subgroups, 1, -1 do
            local Subgroup = Subgroups[j]
            for k = #Subgroup, 1, -1 do
                local Results = Subgroup[k]
                for l = #Results, 1, -1 do
                    local Element = Results[l]
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
                    if Items then
                        table.remove(Results, l)
                        for _, item in pairs(Items) do
                            local Item = GPrefix.Items[item.name]
                            if Item then table.insert(Results, Item) end
                        end
                    end

                    --- --- --- --- --- --- --- --- --- --- ---
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Fusionar los resultados de los filtros indicados
function This_MOD.join_filters()
    for _, join in pairs(This_MOD.join) do
        local Group = GPrefix.get_table(This_MOD.new_order, "name", join.group)
        local Subgroup = GPrefix.get_table(Group, "name", join.subgroup)
        table.sort(join.filters)
        local Aux = {}
        for i = #join.filters, 1, -1 do
            local j = join.filters[i]
            for _, element in pairs(Subgroup[j]) do
                table.insert(Aux, element)
            end
            table.remove(Subgroup, j)
        end
        table.insert(Subgroup, join.filters[1], Aux)
    end
end

--- Eliminar los elementos duplicados - dejar el último
function This_MOD.only_last()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Reordenar para buscar
    local List_elements = {}

    --- Darle el un formato para facilitar la busqueda
    for i = 1, #This_MOD.new_order, 1 do
        local Groups = This_MOD.new_order[i]
        for j = 1, #Groups, 1 do
            local Subgroup = Groups[j]
            for k = 1, #Subgroup, 1 do
                local Results = Subgroup[k]
                for l = 1, #Results, 1 do
                    local Element = Results[l]
                    --- --- --- --- --- --- --- --- --- ---

                    --- Formato deseado
                    table.insert(List_elements, {
                        value = Element,
                        keys = {
                            group = i,
                            subgroup = j,
                            results = k,
                            element = l
                        }
                    })

                    --- --- --- --- --- --- --- --- --- ---
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Elementos a eliminar
    local List_delete = {}

    --- Buscar duplicados
    local Count = #List_elements
    for i = 1, Count - 1, 1 do
        for j = i + 1, Count, 1 do
            local iElement = List_elements[i]
            local jElement = List_elements[j]
            if iElement.value == jElement.value then
                table.insert(List_delete, 1, iElement.keys)
                break
            end
        end
    end

    --- Eliminar los duplicados
    for _, keys in pairs(List_delete) do
        --- Renombrar
        local Group = This_MOD.new_order[keys.group]
        local Subgroup = Group[keys.subgroup]
        local Results = Subgroup[keys.results]

        --- Eliminar el duplicado
        table.remove(Results, keys.element)

        --- Eliminar los filtros vacios
        if #Results == 0 then
            table.remove(Subgroup, keys.results)
        end

        --- Eliminar los subgrupos vacios
        if #Subgroup == 0 then
            table.remove(Group, keys.subgroup)
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Separar los filtros "grandes"
function This_MOD.split_big_taget()
    for i = #This_MOD.new_order, 1, -1 do
        local Group = This_MOD.new_order[i]
        for j = #Group, 1, -1 do
            local Subgroup = Group[j]
            for k = #Subgroup, 1, -1 do
                local Results = Subgroup[k]
                --- --- --- --- --- --- --- --- --- --- ---

                --- Validar filtro y separar los filtros "grandes"
                if #Results > 2 and k > 1 then
                    table.remove(Subgroup, k)
                    table.insert(Group, j + 1, {
                        name = Subgroup.name .. "-" .. k,
                        Results
                    })
                end

                --- --- --- --- --- --- --- --- --- --- ---
            end
        end
    end
end

--- Re-ordenar los subgroups
function This_MOD.sort_subgroups()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Variables a usar
    local Source = {}
    local Orders = {}

    --- Agrupar los subgroups
    for _, subgroup in pairs(GPrefix.subgroups) do
        --- --- --- --- --- --- --- --- --- --- --- --- ---
        Source[subgroup.group] = Source[subgroup.group] or {}
        table.insert(Source[subgroup.group], subgroup)
        --- --- --- --- --- --- --- --- --- --- --- --- ---
        Orders[subgroup.group] = Orders[subgroup.group] or {}
        table.insert(Orders[subgroup.group], subgroup.order)
        --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Ordenar los subgroups
    for group_name, orders in pairs(Orders) do
        --- Orden de los viejos subgrupos
        table.sort(orders)

        --- Cargar los subgrupos
        local New_group = GPrefix.get_table(This_MOD.new_order, "name", group_name)
        local Old_subgroups = Source[group_name]

        --- Cantiad de nuevos subgrupos
        local Count = 0

        --- Eliminar el grupo recorrido
        if New_group then
            local i = GPrefix.get_key(This_MOD.new_order, New_group)
            table.remove(This_MOD.new_order, i)
            Count = #New_group
        end

        --- Digitos a usar
        local Digits = 0
        Digits = Digits + #orders
        Digits = Digits + Count
        Digits = GPrefix.digit_count(Digits) + 1

        --- Crear los nuevos subgrupos
        for i = 1, Count, 1 do
            data:extend({ {
                type = "item-subgroup",
                name = GPrefix.name .. "-" .. New_group[i].name,
                group = group_name,
                order = GPrefix.pad_left_zeros(Digits, i) .. "0"
            } })
        end

        --- Actualizar el order de los viejos subgrupos
        for i, order in pairs(orders) do
            local subgroup = GPrefix.get_table(Old_subgroups, "order", order)
            subgroup.order = GPrefix.pad_left_zeros(Digits, i + Count) .. "0"
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Crear los subgrupos
    for _, New_group in pairs(This_MOD.new_order) do
        --- Digitos a usar
        local Digits = GPrefix.digit_count(#New_group) + 1

        --- Crear los nuevos subgrupos
        for i = 1, #New_group, 1 do
            data:extend({ {
                type = "item-subgroup",
                name = GPrefix.name .. "-" .. New_group[i].name,
                group = New_group.name,
                order = GPrefix.pad_left_zeros(Digits, i) .. "0"
            } })
        end
    end
end

--- Re-ordenar los objetivos
function This_MOD.sort_items()
    for i = #This_MOD.new_order, 1, -1 do
        local Groups = This_MOD.new_order[i]
        for j = #Groups, 1, -1 do
            local Subgroup = Groups[j]

            --- --- --- --- --- --- --- --- --- --- --- ---
            ---> Variables a usar
            --- --- --- --- --- --- --- --- --- --- --- ---
            local Source = {} --- Elementos del subgrupo
            local Orders = {} --- Orden a usar
            --- --- --- --- --- --- --- --- --- --- --- ---

            for k = #Subgroup, 1, -1 do
                local Results = Subgroup[k]
                for l = #Results, 1, -1 do
                    local Element = Results[l]
                    --- --- --- --- --- --- --- --- --- ---
                    ---> Formato deseado
                    --- --- --- --- --- --- --- --- --- ---
                    Element.order = Element.order or ""
                    local New_order = Element.subgroup
                    New_order = New_order and GPrefix.subgroups[New_order].order or ""
                    New_order = New_order .. "-"
                    New_order = New_order .. GPrefix.pad_left_zeros(2, k) .. "-"
                    New_order = New_order .. Element.order
                    Element.order = New_order
                    --- --- --- --- --- --- --- --- --- ---



                    --- --- --- --- --- --- --- --- --- ---
                    ---> Separarlos valores
                    --- --- --- --- --- --- --- --- --- ---
                    table.insert(Orders, New_order)
                    table.insert(Source, Element)
                    --- --- --- --- --- --- --- --- --- ---
                end
            end

            --- --- --- --- --- --- --- --- --- --- --- ---
            ---> Ordenar los elementos
            --- --- --- --- --- --- --- --- --- --- --- ---
            table.sort(Orders)
            local Digits = GPrefix.digit_count(#Orders) + 1
            for key, order in pairs(Orders) do
                local Element = GPrefix.get_table(Source, "order", order)
                Element.order = GPrefix.pad_left_zeros(Digits, key) .. "0"
                Element.subgroup = GPrefix.name .. "-" .. Subgroup.name
            end
            --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end
end

--- Hacer algunas correciones
function This_MOD.correct()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Ocultar las recetas para vaciar los barriles
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    local Empty_barrels = This_MOD.new_order
    Empty_barrels = GPrefix.get_table(Empty_barrels, "name", "intermediate-products")
    Empty_barrels = GPrefix.get_table(Empty_barrels, "name", "recipes-empty-barrels")

    for _, recipe in pairs(Empty_barrels[1]) do
        -- recipe.subgroup = This_MOD.subgroup
        recipe.allow_decomposition = false
        recipe.hide_from_signal_gui = false
        recipe.hide_from_player_crafting = true
        recipe.factoriopedia_alternative = 'barrel'
    end
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---



    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Eliminar subgroup y order
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    for _, entity in pairs(data.raw['combat-robot']) do
        entity.subgroup = nil
        entity.order = nil
    end
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Agrupar las recetas
function This_MOD.closer_together()
    for name, recipes in pairs(GPrefix.Recipes) do
        local Item = GPrefix.Items[name]
        if Item then
            Item.order = Item.order or "0"
            local New_order = tonumber(Item.order) or 0
            for _, recipe in pairs(recipes) do
                if #recipe.results == 1 then
                    recipe.subgroup = Item.subgroup
                    recipe.order = GPrefix.pad_left_zeros(#Item.order, New_order)
                    New_order = New_order + 1
                end
            end
        end
    end
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
This_MOD.start()
-- GPrefix.var_dump(GPrefix.subgroups)
-- GPrefix.var_dump(data.raw["item-group"])

---------------------------------------------------------------------------------------------------
