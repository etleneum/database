function __init__ ()
  return {}
end

function dosomething ()
  if call.msatoshi < 1000 then
    error('pay more!')
  end

  contract.state.something = call.payload.something
end