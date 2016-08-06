local shader = {source, screenSource, enabled = false}
addEventHandler("onClientResourceStart", resourceRoot, function()
	shader.source = dxCreateShader("shader/shaderFiles/BlurShader.fx")
	shader.screenSource = dxCreateScreenSource(x, y)
end)

local function drawShader()
	if shader.source then
		dxUpdateScreenSource(shader.screenSource)
		dxSetShaderValue(shader.source, "ScreenSource", shader.screenSource)
		dxSetShaderValue(shader.source, "BlurStrength", 100/80*(80-g_shaderDistance))
		dxSetShaderValue(shader.source, "UVSize", x, y)
		dxDrawImage(0, 0, x, y, shader.source)
	end
end

function toggleBlurShader(state)
	if state then
		if not shader.enabled then
			shader.enabled = true
			addEventHandler("onClientPreRender", root, drawShader)
		end
	elseif not state then
		if shader.enabled then
			shader.enabled = false
			removeEventHandler("onClientPreRender", root, drawShader)
		end
	end
end