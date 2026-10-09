do
	do
		do
			local obj, obj2, fn35, fn36

			do
				do
					Players = game:GetService("Players")
					TweenService = game:GetService("TweenService")
					UIS = game:GetService("UserInputService")
					RunService = game:GetService("RunService")
					Lighting = game:GetService("Lighting")
					HS = game:GetService("HttpService")
					player = Players.LocalPlayer
					ReplicatedStorage = game:GetService("ReplicatedStorage")
					toggleRefs = {}
					actionKeybinds = {}
					searchableItems = {}
					List = Instance.new("Frame")
					layoutOrderCounter = 0

					LO = function()
						layoutOrderCounter += 1
						return layoutOrderCounter
					end

					corner = function(parent, radius)
						local uiCorner = Instance.new("UICorner")
						uiCorner.CornerRadius = UDim.new(0, radius or 8)
						uiCorner.Parent = parent
						return uiCorner
					end

					stroke = function(parent, color, thickness, transparency)
						local uiStroke = Instance.new("UIStroke")
						uiStroke.Color = color
						uiStroke.Thickness = thickness or 1
						uiStroke.Transparency = transparency or 0
						uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						uiStroke.Parent = parent
						return uiStroke
					end

					tween = function(object, properties, duration)
						TweenService:Create(
							object,
							TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							properties
						):Play()
					end

					getActiveStealDuration = function()
						return math.max(0.05, tonumber(Steal.StealDuration) or 0.2)
					end

					saveSettings = function()
						if saveConfig then
							saveConfig()
						end
					end

					pcall(function()
						local CoreGui = game:GetService("CoreGui")
						local playerGui = player:WaitForChild("PlayerGui")

						for _, v86 in ipairs({
							"PhantomLoader",
							"VanityLoadingScreen",
							"VENOMDuelsLoadingScreen",
							"VanityDeviceSelect",
							"VENOMDuelsDeviceSelect",
							"PhantomHub",
							"PhantomStealBar",
						}) do
							if CoreGui then
								local v87 = CoreGui:FindFirstChild(v86)

								if v87 then
									v87:Destroy()
								end
							end

							if playerGui then
								local v87 = playerGui:FindFirstChild(v86)

								if v87 then
									v87:Destroy()
								end
							end
						end
					end)

					loaderFinished = false
					skipLoadingScreen = false
					introEnabled = true

					VENOMDUELS_INTRO_TRACKS = {
						["Main"] = {
							url = "https://cdn.imageurlgenerator.com/uploads/95917463-1685-4722-aa99-4d6d7b065d53.mp3",
							file = "VENOMduels_clean_intro.mp3",
						},
						["Song 2"] = {
							url = "https://cdn.imageurlgenerator.com/uploads/63c0949b-d95f-44c0-8aee-1531873398c2.mp3",
							file = "VENOMduels_song_2_intro.mp3",
						},
						["Song 3"] = {
							url = "https://cdn.imageurlgenerator.com/uploads/a68037de-fc9c-46c9-8d12-96c83a4703ea.mp3",
							file = "VENOMduels_song_3_intro.mp3",
						},
					}

					introSongChoice = "Main"
					introSoundInstance = nil
					introMusicRequest = 0

					stopVENOMDuelsIntroMusic = function()
						introMusicRequest = (introMusicRequest or 0) + 1

						if introSoundInstance then
							pcall(function()
								introSoundInstance:Stop()
							end)

							pcall(function()
								introSoundInstance:Destroy()
							end)

							introSoundInstance = nil
						end
					end

					playVENOMDuelsIntroMusic = function()
						if not introSoundEnabled then
							return
						end
						introMusicRequest = (introMusicRequest or 0) + 1
						local v86 = introMusicRequest
						local main = VENOMDUELS_INTRO_TRACKS[introSongChoice] or VENOMDUELS_INTRO_TRACKS.Main

						local function fn37()
							if introMusicRequest ~= v86 or not introSoundEnabled then
								return
							end

							pcall(function()
								if introSoundInstance then
									introSoundInstance:Destroy()
								end

								introSoundInstance = Instance.new("Sound")
								local soundId = nil

								if getcustomasset then
									local ok

									ok, soundId = pcall(function()
										return getcustomasset(main.file)
									end)

									local v87 = nil

									if not ok then
										soundId = v87
									end
								end

								introSoundInstance.SoundId = soundId or main.url
								introSoundInstance.Volume = 1
								introSoundInstance.Looped = false
								introSoundInstance.Parent = game:GetService("CoreGui")
								introSoundInstance:Play()
							end)
						end

						local v87 = false

						pcall(function()
							if isfile and isfile(main.file) then
								v87 = true
							end
						end)

						if v87 then
							fn37()
						else
							task.spawn(function()
								local ok, result = pcall(function()
									return game:HttpGet(main.url)
								end)

								if ok and result and introMusicRequest == v86 then
									if writefile then
										pcall(function()
											writefile(main.file, result)
										end)
									end

									fn37()
								end
							end)
						end

						return
					end

					task.spawn(function()
						if makefolder and isfolder and not isfolder("VENOMDuelsV1configLOL1") then
							pcall(makefolder, "VENOMDuelsV1configLOL1")
						end

						introSoundEnabled = true
						introSongChoice = "Main"

						if isfile and isfile("VENOMDuelsV1configLOL1/Config.json") then
							local ok, result = pcall(function()
								return HS:JSONDecode(readfile("VENOMDuelsV1configLOL1/Config.json"))
							end)

							if ok and type(result) == "table" then
								if type(result.introEnabled) == "boolean" then
									introEnabled = result.introEnabled
								end

								if result.introSoundEnabled ~= nil then
									introSoundEnabled = result.introSoundEnabled
								end

								local v86 = "string"

								if
									type(result.introSongChoice) == v86
									and VENOMDUELS_INTRO_TRACKS[result.introSongChoice]
								then
									introSongChoice = result.introSongChoice
								end
							end
						end

						if not introEnabled then
							stopVENOMDuelsIntroMusic()
							loaderFinished = true
							return
						end

						playVENOMDuelsIntroMusic()
						local playerGui = player:WaitForChild("PlayerGui")

						pcall(function()
							local service = game:GetService("CoreGui")

							if service then
								playerGui = service
							end
						end)

						local VENOMDuelsLoadingScreen = playerGui:FindFirstChild("VENOMDuelsLoadingScreen")

						if VENOMDuelsLoadingScreen then
							VENOMDuelsLoadingScreen:Destroy()
						end

						local instance = Instance.new("ScreenGui")
						instance.Name = "VENOMDuelsLoadingScreen"
						instance.ResetOnSpawn = false
						instance.IgnoreGuiInset = true
						instance.DisplayOrder = 999
						instance.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
						instance.Parent = playerGui

						pcall(function()
							if syn and syn.protect_gui then
								syn.protect_gui(instance)
							end
						end)

						local frame = Instance.new("Frame")
						frame.Name = "Background"
						frame.Size = UDim2.fromScale(1, 1)
						frame.Position = UDim2.fromScale(0, 0)
						frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						frame.BorderSizePixel = 0
						frame.ZIndex = 1
						frame.Parent = instance
						local uiGradient = Instance.new("UIGradient", frame)
						local colorSequence = ColorSequence.new
						local tbl17 = {}
						local v86 = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
						local v87 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 12))
						tbl17[1] = v86
						tbl17[2] = v87

						do
							local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)))
							table.move(values, 1, values.n, 3, tbl17)
						end

						uiGradient.Color = colorSequence(tbl17)
						uiGradient.Rotation = 90
						local frame2 = Instance.new("Frame")
						frame2.Name = "MainContainer"
						frame2.Size = UDim2.fromOffset(420, 500)
						frame2.AnchorPoint = Vector2.new(0.5, 0.5)
						frame2.Position = UDim2.fromScale(0.5, 0.48)
						frame2.BackgroundTransparency = 1
						frame2.ZIndex = 2
						frame2.Parent = frame
						local uiListLayout = Instance.new("UIListLayout", frame2)
						uiListLayout.FillDirection = Enum.FillDirection.Vertical
						uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
						uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
						uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
						uiListLayout.Padding = UDim.new(0, 14)
						local frame3 = Instance.new("Frame", frame2)
						frame3.Name = "LogoContainer"
						frame3.Size = UDim2.fromOffset(560, 110)
						frame3.BackgroundTransparency = 1
						frame3.LayoutOrder = 1
						frame3.ZIndex = 2
						local uiListLayout2 = Instance.new("UIListLayout", frame3)
						uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
						uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
						uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
						uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
						local instance2 = Instance.new("TextLabel", frame3)
						instance2.Name = "VENOMDuels"
						instance2.Size = UDim2.fromOffset(520, 110)
						instance2.BackgroundTransparency = 1
						instance2.Text = "VENOM"
						instance2.TextColor3 = Color3.fromRGB(255, 255, 255)
						instance2.Font = Enum.Font.GothamBlack
						instance2.TextScaled = true
						instance2.TextXAlignment = Enum.TextXAlignment.Right
						instance2.LayoutOrder = 1
						instance2.ZIndex = 2
						instance2.TextTransparency = 1
						local textLabel = Instance.new("TextLabel", frame3)
						textLabel.Name = "VS"
						textLabel.Size = UDim2.fromOffset(140, 110)
						textLabel.BackgroundTransparency = 1
						textLabel.Text = "DUELS"
						textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						textLabel.Font = Enum.Font.GothamBlack
						textLabel.TextScaled = true
						textLabel.TextXAlignment = Enum.TextXAlignment.Left
						textLabel.LayoutOrder = 2
						textLabel.ZIndex = 2
						textLabel.TextTransparency = 1
						local textLabel2 = Instance.new("TextLabel", frame2)
						textLabel2.Name = "Subtitle"
						textLabel2.Size = UDim2.fromOffset(600, 42)
						textLabel2.BackgroundTransparency = 1
						textLabel2.Text = "Welcome " .. player.Name
						textLabel2.TextColor3 = Color3.fromRGB(240, 240, 240)
						textLabel2.Font = Enum.Font.GothamMedium
						textLabel2.TextScaled = true
						textLabel2.LayoutOrder = 2
						textLabel2.ZIndex = 2
						textLabel2.TextTransparency = 1
						local textLabel3 = Instance.new("TextLabel", frame2)
						textLabel3.Name = "Thanks"
						textLabel3.Size = UDim2.fromOffset(600, 30)
						textLabel3.BackgroundTransparency = 1
						textLabel3.Text = "BEST FREE DUEL SCRIPT"
						textLabel3.TextColor3 = Color3.fromRGB(210, 210, 210)
						textLabel3.Font = Enum.Font.Gotham
						textLabel3.TextScaled = true
						textLabel3.LayoutOrder = 3
						textLabel3.ZIndex = 2
						textLabel3.TextTransparency = 1
						local frame4 = Instance.new("Frame", frame2)
						frame4.Name = "Spacer"
						frame4.Size = UDim2.fromOffset(1, 20)
						frame4.BackgroundTransparency = 1
						frame4.LayoutOrder = 4
						local instance3 = Instance.new("Frame", frame2)
						instance3.Name = "BarBackground"
						instance3.Size = UDim2.fromOffset(320, 6)
						instance3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
						instance3.BorderSizePixel = 0
						instance3.ZIndex = 2
						instance3.BackgroundTransparency = 1
						instance3.LayoutOrder = 5
						Instance.new("UICorner", instance3).CornerRadius = UDim.new(1, 0)
						local frame5 = Instance.new("Frame", instance3)
						frame5.Name = "Fill"
						frame5.Size = UDim2.fromScale(0, 1)
						frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						frame5.BorderSizePixel = 0
						frame5.ZIndex = 3
						Instance.new("UICorner", frame5).CornerRadius = UDim.new(1, 0)
						local colorSequence2 = ColorSequence.new

						Instance.new("UIGradient", frame5).Color = colorSequence2({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
						})

						local textLabel4 = Instance.new("TextLabel", frame)
						textLabel4.Name = "Footer"
						textLabel4.Size = UDim2.fromOffset(600, 25)
						textLabel4.AnchorPoint = Vector2.new(0.5, 1)
						textLabel4.Position = UDim2.fromScale(0.5, 0.97)
						textLabel4.BackgroundTransparency = 1
						textLabel4.Text = "VENOM DUELS  /  INITIALIZING"
						textLabel4.TextColor3 = Color3.fromRGB(120, 120, 120)
						textLabel4.Font = Enum.Font.Gotham
						textLabel4.TextScaled = true
						textLabel4.ZIndex = 2
						textLabel4.TextTransparency = 1

						local function fn37(arg, arg2, arg3, arg4, arg5)
							local tween_ = TweenService:Create(
								arg,
								TweenInfo.new(
									arg3 or 0.5,
									arg4 or Enum.EasingStyle.Quad,
									arg5 or Enum.EasingDirection.Out
								),
								arg2
							)
							tween_:Play()
							return tween_
						end

						fn37(instance2, { TextTransparency = 0 }, 0.4)
						fn37(textLabel, { TextTransparency = 0 }, 0.6)
						task.wait(0.3)
						fn37(textLabel2, { TextTransparency = 0 }, 0.5)
						task.wait(0.15)
						fn37(textLabel3, { TextTransparency = 0 }, 0.5)
						task.wait(0.5)
						fn37(instance3, { BackgroundTransparency = 0 }, 0.4)
						task.wait(0.1)
						fn37(textLabel4, { TextTransparency = 0.3 }, 0.5)
						fn37(
							frame5,
							{ Size = UDim2.fromScale(1, 1) },
							1.6,
							Enum.EasingStyle.Quad,
							Enum.EasingDirection.InOut
						)
						task.wait(1)

						if instance then
							local v88 = fn37(frame, { BackgroundTransparency = 1 }, 1)
							fn37(instance2, { TextTransparency = 1 }, 0.6)
							fn37(textLabel, { TextTransparency = 1 }, 0.6)
							fn37(textLabel2, { TextTransparency = 1 }, 0.4)
							fn37(textLabel3, { TextTransparency = 1 }, 0.6)
							fn37(instance3, { BackgroundTransparency = 1 }, 0.6)
							fn37(frame5, { BackgroundTransparency = 1 }, 0.6)
							fn37(textLabel4, { TextTransparency = 1 }, 0.4)
							v88.Completed:Wait()
						end

						if instance then
							instance:Destroy()
						end

						loaderFinished = true
					end)

					repeat
						task.wait()
					until loaderFinished

					repeat
						task.wait()
					until game:IsLoaded()

					_phantomModeIsMobile = false
					_phantomSavedDeviceMode = nil
					_savedGuiScale = nil

					do
						local json = isfile and isfile("VENOMDuelsV1configLOL1/Config.json")
						local deviceMode = nil

						if json then
							local ok, result = pcall(function()
								return HS:JSONDecode(readfile("VENOMDuelsV1configLOL1/Config.json"))
							end)

							if ok then
								local v86 = "table"
								ok = type(result) == v86
							end

							ok = ok and (result.deviceMode == "pc" or result.deviceMode == "mobile")
							deviceMode = nil

							if ok then
								deviceMode = result.deviceMode
							end
						end

						if deviceMode then
							_phantomSavedDeviceMode = deviceMode
							_phantomModeIsMobile = deviceMode == "mobile"
						else
							_phantomModeIsMobile = UIS.TouchEnabled == true
								and not (UIS.KeyboardEnabled == true)
								and not (UIS.MouseEnabled == true)
							_phantomSavedDeviceMode = _phantomModeIsMobile and "mobile" or "pc"

							pcall(function()
								if makefolder and isfolder and not isfolder("VENOMDuelsV1configLOL1") then
									makefolder("VENOMDuelsV1configLOL1")
								end

								local tbl17 = {}

								if isfile and isfile("VENOMDuelsV1configLOL1/Config.json") then
									local ok, result = pcall(function()
										return HS:JSONDecode(readfile("VENOMDuelsV1configLOL1/Config.json"))
									end)

									if ok and type(result) == "table" then
										tbl17 = result
									end
								end

								tbl17.deviceMode = _phantomSavedDeviceMode

								if writefile then
									writefile("VENOMDuelsV1configLOL1/Config.json", HS:JSONEncode(tbl17))
								end
							end)
						end
					end
				end

				do
					local n32, n33, n34, n35, n36, obj3, obj4, fn37

					do
						CANDY_SKY_TAG = "PhantomSkyTheme"
						currentSkyTheme = "Night"

						CANDY_SKY_PRESETS = {
							Off = { kind = "off" },
							Night = {
								clock = 22,
								brightness = 2,
								ambient = { 110, 100, 120 },
								outAmb = { 120, 110, 140 },
								sky = {
									stars = 4000,
									moon = 18,
									sun = 0,
									moonTex = true,
								},
								atm = {
									dens = 0.45,
									color = { 120, 60, 180 },
									decay = { 60, 20, 100 },
									glare = 0.5,
									haze = 1.2,
								},
							},
							Aurora = {
								clock = 14,
								brightness = 3,
								ambient = { 140, 120, 140 },
								outAmb = { 160, 130, 150 },
								atm = {
									dens = 0.4,
									color = { 255, 80, 205 },
									decay = { 255, 20, 150 },
									glare = 2.5,
									haze = 3,
								},
								clouds = {
									cover = 0.7,
									dens = 1,
									color = { 255, 240, 250 },
								},
							},
							["Sunset"] = {
								clock = 17.5,
								brightness = 2.5,
								ambient = { 170, 120, 100 },
								outAmb = { 180, 120, 110 },
								sky = { stars = 0, sun = 25, moon = 0 },
								atm = {
									dens = 0.5,
									color = { 255, 130, 60 },
									decay = { 255, 80, 30 },
									glare = 2,
									haze = 2.5,
								},
								clouds = {
									cover = 0.4,
									dens = 0.55,
									color = { 255, 205, 140 },
								},
							},
							["Galaxy"] = {
								clock = 0,
								brightness = 1.5,
								ambient = { 70, 60, 100 },
								outAmb = { 200, 70, 110 },
								sky = {
									stars = 10000,
									moon = 30,
									sun = 0,
								},
								atm = {
									dens = 0.5,
									color = { 40, 20, 200 },
									decay = { 20, 10, 50 },
									glare = 0.3,
									haze = 0.5,
								},
							},
							["Candy"] = {
								clock = 21,
								brightness = 2.2,
								ambient = { 90, 130, 170 },
								outAmb = { 100, 140, 180 },
								sky = { stars = 2000, moon = 12 },
								atm = {
									dens = 0.4,
									color = { 0, 205, 255 },
									decay = { 140, 0, 255 },
									glare = 2,
									haze = 2,
								},
								clouds = {
									cover = 0.4,
									dens = 0.6,
									color = { 100, 200, 255 },
								},
							},
							["Blood Moon"] = {
								clock = 23,
								brightness = 1.6,
								ambient = { 120, 40, 40 },
								outAmb = { 140, 50, 50 },
								sky = {
									stars = 1500,
									moon = 28,
									sun = 0,
									moonTex = true,
								},
								atm = {
									dens = 0.6,
									color = { 220, 30, 30 },
									decay = { 120, 10, 10 },
									glare = 1.4,
									haze = 2,
								},
								clouds = {
									cover = 0.5,
									dens = 0.7,
									color = { 120, 30, 30 },
								},
							},
							["Vapor"] = {
								clock = 19.5,
								brightness = 2.4,
								ambient = { 180, 120, 200 },
								outAmb = { 190, 130, 210 },
								sky = { stars = 3000, moon = 14 },
								atm = {
									dens = 0.45,
									color = { 255, 100, 220 },
									decay = { 120, 60, 255 },
									glare = 2.2,
									haze = 1,
								},
								clouds = {
									cover = 0.5,
									dens = 0.55,
									color = { 205, 140, 255 },
								},
							},
							Hellfire = {
								clock = 18,
								brightness = 1.8,
								ambient = { 200, 60, 30 },
								outAmb = { 220, 70, 36 },
								sky = {
									stars = 100,
									sun = 30,
									moon = 0,
								},
								atm = {
									dens = 0.5,
									color = { 255, 30, 0 },
									decay = { 120, 0, 0 },
									glare = 3.5,
									haze = 4,
								},
								clouds = {
									cover = 0.95,
									dens = 0.5,
									color = { 80, 20, 10 },
								},
							},
							Heaven = {
								clock = 12,
								brightness = 4,
								ambie
