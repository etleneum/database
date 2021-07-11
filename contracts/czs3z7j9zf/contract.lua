function __init__ ()
  return {hue=0}
end

function sethue ()
  if call.msatoshi < 10000 then
    error('pay at least 10 sat!')
  end

  if type(call.payload.hue) ~= 'number' then
    error('hue is not a number!')
  end

  if call.payload.hue < 0 or call.payload.hue > 360 then
    error('hue is out of the 0~360 range!')
  end

  contract.state.hue = call.payload.hue
  contract.send('02c9323d02fc164f89c8f688dbfba8aad69a96fa8f6253ba8cce2c6f1546073fa3', call.msatoshi)
end