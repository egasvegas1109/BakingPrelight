-- Функция для создания 4 Target Spot и объединения их в selectionSet
fn createTargetSpots = (
    local setName = "Light_Set" -- Название набора
    local existingSet = undefined
    local lightsArray = #() -- Массив для хранения созданных источников

    -- Проверяем, существует ли уже selectionSet с таким именем
    for s in selectionSets where s.name == setName do (
        existingSet = s
    )

    if existingSet != undefined then (
        messageBox "Набор источников света уже существует." title:"Ошибка"
    ) 
    else 
    (
        local positions = #([0,500,200], [500,0,200], [0,-500,200], [-500,0,200])  -- Координаты источников света
        local lightsArray = #()  -- Массив для хранения источников света
        local targetsArray = #()  -- Массив для хранения целей

        -- Создание света и целей
        for i = 1 to positions.count do (
            local target = TargetObject()  
            target.position = [0,0,0]       
            append targetsArray target  -- Добавляем цель в отдельный массив
            
            local spot = TargetSpot target:target 
            spot.position = positions[i]   
            append lightsArray spot  -- Добавляем источник света в массив
        )
        
        lightsArray[1].multiplier = 15.0
        lightsArray[2].multiplier = 35.0
        lightsArray[3].multiplier = 50.0
        lightsArray[4].baseObject = lightsArray[2].baseObject
        lightsArray[4].multiplier = 35.0

        if lightsArray.count == 4 then (
            selectionSets[setName] = lightsArray + targetsArray -- Создаем selectionSet
        )
    )
)

-- Функция запекания Vertex Color через Radiosity
fn bakeVertexColor = (
    sceneradiosity.radiosity.reset true true
    sceneradiosity.radiosity.start()														
)

-- Создание интерфейса
rollout textureMaterialApplicator "BakingPrelight | Malinovka"(
    button btn_about "About" width:92 height:23 align:#right
    label prgrs_bar_name ""
    progressbar prgrs_bar color:green
    button btnApply "Create Target Spots" width:150 align:#center
    button btnBakeVC "Bake Vertex Color" width:150 align:#center
    
    on btn_about pressed do (
        rollout rol_meChecker_about "BakingPrelight | Malinovka - About" width:295 (
            label lbl1 "BakingPrelight | Malinovka 1.0" height:17
            label lbl6 "Script features:" pos:[11,33] 
            label lbl7 "- Mass overlay of materials" pos:[13,53] 
            label lbl11 "_____________________________"
            label lbl2 "\xa9 by " pos:[10,133] width:42 height:18
            HyperLink Malinovka "Malinovka" pos:[37,133] width:60 height:18 address:"https://malinovka.org" color:(color 10 147 225) hovercolor:(color 94 198 255) visitedcolor:(color 10 147 225)
            button btn_close "close" pos:[215,133] width:69 height:22
            on btn_close pressed do DestroyDialog rol_meChecker_about 
        )
        createDialog rol_meChecker_about modal:true 
    )

    on btnApply pressed do (
        createTargetSpots() -- Вызываем функцию создания Target Spot
    )

    on btnBakeVC pressed do (
        bakeVertexColor() -- Запекаем Vertex Color
    )
)

fn checkRadiosityAvailability = (
    if (sceneradiosity.radiosity == undefined) then (
        messageBox "Включите Radiosity.\n F10 -> Advanced Lighting -> Select Advanced Lighting -> Radiosity" title:"Ошибка"
        return false
    )
    sceneradiosity.radiosity.radFiltering = 3
    sceneradiosity.radiosity.radDirectFiltering = 10
    
    return true
)

-- Отображение интерфейса
if checkRadiosityAvailability() then (
    createDialog textureMaterialApplicator 340 130
)