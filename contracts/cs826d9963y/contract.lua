function __init__ ()
  return {
    deposits = {},
    loan_requests = {},
    outstanding_loans = {}
  }
end

function deposit ()
  if not account.id then
    error('must be authenticated')
  end

  contract.state.deposits[account.id] = contract.state.deposits[account.id] or 0
  contract.state.deposits[account.id] = contract.state.deposits[account.id] + call.msatoshi
end

function request_loan ()
  if not account.id then
    error('must be authenticated')
  end

  -- this will reset any previous requests
  contract.state.loan_requests[account.id] = {
    amount = call.payload.amount,
    approvals = {}
  }
end

function loan_approve ()
  if not account.id then
    error('must be authenticated')
  end

  if not contract.state.deposits[account.id] then
    error('must be a member of this group')
  end

  contract.state.loan_requests[call.payload.requester].approvals[account.id] = true
end

function loan_withdraw ()
  if not account.id then
    error('must be authenticated')
  end

  loan = contract.state.loan_requests[account.id]

  local total_members = 0
  local total_approvals = 0

  for _, _ in pairs(contract.state.deposits) do
    total_members = total_members + 1
  end

  for _, _ in pairs(loan.approvals) do
    total_approvals = total_approvals + 1
  end

  if total_approvals == total_members then
    contract.send(account.id, loan.amount)
    contract.state.loan_requests[account.id] = nil
    contract.state.outstanding_loans[account.id] = loan.amount
    utils.print('loan withdrawn')
  else
    error('loan not approved by everybody yet')
  end
end

function loan_pay ()
  if not account.id then
    error('must be authenticated')
  end

  contract.state.outstanding_loans[account.id] = contract.state.outstanding_loans[account.id] - call.msatoshi

  if contract.state.outstanding_loans[account.id] <= 0 then
    contract.state.outstanding_loans[account.id] = nil
    utils.print('loan repaid fully')
  end
end
