local AwaitingEvent = {}
local UsingClipBoard = false

NewQuiz = function(title,questions,reqPass, eventtype, event, args)
  AwaitingEvent.Name = event
  AwaitingEvent.Type = eventtype
  AwaitingEvent.Args = args
  SetNuiFocus(true,true)
  if UsingClipBoard then 
    askStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", -1, true)
  end
  SendNUIMessage({
    type    = "newQuiz",
    title = title, 
    questions = questions, 
    reqPass = reqPass, 
  })
end

RegisterNUICallback("return", function(data,cb)
  if UsingClipBoard then 
    ClearPedTasksImmediately(PlayerPedId())
    ClearAllPedProps(PlayerPedId())
  end
  SetNuiFocus(false,false)
  if AwaitingEvent then
    if AwaitingEvent.Type == "client" then 
      TriggerEvent(AwaitingEvent.Name, data.passedQuiz, AwaitingEvent.Args)
    elseif AwaitingEvent.Type == "server" then 
      TriggerServerEvent(AwaitingEvent.Name, data.passedQuiz, AwaitingEvent.Args)
    end
    AwaitingEvent = {}
  end
end)









