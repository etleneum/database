function __init__ ()
  return {}
end

function topup ()
  local money = call.msatoshi
  local fee = math.ceil(money/10000)
  contract.send(call.payload.receiver, money - fee)

contract.send('03778d61d51153c0917abd5858b3c8dc48717d6f10b9ab54eee25a94e56b9d66c9', fee)
end
