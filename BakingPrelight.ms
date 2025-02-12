-- Функция для создания 4 Target Spot и объединения их в selectionSet
fn createTargetSpots = (
    local setName = "Light_Set" -- Название набора
    local existingSet = undefined

    -- Проверяем, существует ли уже selectionSet с таким именем
    for s in selectionSets where s.name == setName do (
        existingSet = s
    )

    if existingSet == undefined then ( -- Если сета нет, создаем источники света
        local positions = #([0,100,50], [100,0,50], [0,-100,50], [-100,0,50])  -- Координаты источников света
        local lightsArray = #() -- Массив для хранения созданных источников

        for pos in positions do (
            local target = Targetobject()  -- Создание цели
            target.pos = [0,0,0]           -- Установка цели в центр
            local spot = TargetSpot target:target -- Создание Target Spot и привязка к цели
            spot.pos = pos                  -- Установка позиции
            append lightsArray spot         -- Добавляем в массив
            append lightsArray target       -- Добавляем цель в массив
        )

        if lightsArray.count == 8 then (
            selectionSets[setName] = lightsArray -- Создаем selectionSet
        )

    ) else (
        messageBox "Набор 'Light_Set' уже существует. Новые источники света не созданы." title:"Внимание"
    )
)

-- Создание интерфейса
rollout textureMaterialApplicator "BakingPrelight | Malinovka"(
    -- About
    button btn_about "About" width:92 height:23 align:#right
    -- Main
    label prgrs_bar_name ""
    progressbar prgrs_bar color:green
    -- Кнопка создания источников света
    button btnApply "Create Target Spots" width:150 align:#center
    
    -----------------------ОБРАБОТЧИКИ КНОПОК-----------------------
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
)

-- Отображение интерфейса
createdialog textureMaterialApplicator 340 350
