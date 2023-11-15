
struct Identification3 <: MathProgBase.AbstractNLPEvaluator
    F::Matrix{Float64}
    L::Matrix{Float64}
end

function MathProgBase.initialize(d::Identification3, requested_features::Vector{Symbol})
    for feat in requested_features
        if !(feat in [:Grad, :Jac, :Hess])
            error("Unsupported feature $feat")
        end
    end
end

MathProgBase.features_available(d::Identification3) = [:Grad, :Jac]

function MathProgBase.eval_f(d::Identification3, x)
    ## x containes U in row major-form
    U = reshape(x, 3, 3)
    x = (d.F*U)[:, 3]
    .5*x'x/size(d.F,1)
end

function MathProgBase.eval_g(d::Identification3, g, x)
    Λ = d.L
    g[1]  = x[1]^2 + x[4]^2 + x[7]^2
    g[2]  = x[2]^2 + x[5]^2 + x[8]^2
    g[3]  = x[3]^2 + x[6]^2 + x[9]^2
    g[4]  = x[1]*x[2] + x[4]*x[5] + x[7]*x[8]
    g[5]  = x[1]*x[3] + x[4]*x[6] + x[7]*x[9]
    g[6]  = x[2]*x[3] + x[5]*x[6] + x[8]*x[9]
    g[7]  = x[4]*Λ[1,1] + x[5]*Λ[1,2] + x[6]*Λ[1,3]
    g[8]  = x[7]*Λ[1,1] + x[8]*Λ[1,2] + x[9]*Λ[1,3]
end

function wcon3(d, x)
    Λ = d.L
    [x[1]^2 + x[4]^2 + x[7]^2,
    x[2]^2 + x[5]^2 + x[8]^2,
    x[3]^2 + x[6]^2 + x[9]^2,
    x[1]*x[2] + x[4]*x[5] + x[7]*x[8],
    x[1]*x[3] + x[4]*x[6] + x[7]*x[9],
    x[2]*x[3] + x[5]*x[6] + x[8]*x[9],
    x[4]*Λ[1,1] + x[5]*Λ[1,2] + x[6]*Λ[1,3],
    x[7]*Λ[1,1] + x[8]*Λ[1,2] + x[9]*Λ[1,3]]
end

function wobj3(d, x)
    U = reshape(x, 3, 3)
    x = (d.F*U)[:, 3]
    .5*x'x/size(d.F,1)
end

function MathProgBase.eval_grad_f(d::Identification3, grad_f, x)
    grad_f[:] = ForwardDiff.gradient(w -> wobj3(d, w), x)
end

MathProgBase.jac_structure(d::Identification3) = repeat(1:8, outer=9), repeat(1:9, inner=8)

function MathProgBase.eval_jac_g(d::Identification3, J, x)
    J[:] = ForwardDiff.jacobian(w -> wcon3(d, w), x)
end

function rotate3(X, DATE, date::Date; scaleby = (:full, :full))
    idx_date = (findfirst(DATE[:,1] .== date))
    end_date = size(DATE, 1)
    idx_pre  = 1:(idx_date-1)
    idx_post = idx_date:end_date

    fm = FactorModel(X.*100)
    Factotum.describe(fm)

    scale = std(fm.factors[:,1:3], dims=1)

    F = fm.factors[:,1:3]./scale

    ID = Identification3(F[idx_pre,:], fm.loadings[:,1:3].*scale);

    crit = Factotum.Criteria(BIC3, fm, 4)
    @show crit
    # W0 = Factotum.waldtest(fm, 0)
    # W1 = Factotum.waldtest(fm, 1)
    # W2 = Factotum.waldtest(fm, 2)

    m = MathProgBase.NonlinearModel(Ipopt.Optimizer)
    l = [-Inf, -Inf, -Inf, -Inf, -Inf, -Inf, -Inf, -Inf, -Inf]
    u = [+Inf, +Inf, +Inf, +Inf, +Inf, +Inf, +Inf, +Inf, +Inf]
    lb = [1., 1., 1., 0., 0., 0., 0., 0.]
    ub = [1., 1., 1., 0., 0., 0., 0., .0]
    MathProgBase.loadproblem!(m, 9, 8, l, u, lb, ub, :Min, ID)
    MathProgBase.setwarmstart!(m, vec(diagm(0 => [1,1,1])))
    MathProgBase.optimize!(m)
    U = reshape(MathProgBase.SolverInterface.getsolution(m), 3, 3)
    Λ = fm.loadings[:,1:3].*scale
    (F*U, Λ*U, U, F, crit, MathProgBase.SolverInterface.getobjval(m), fm.factors[:,1:3]*U)
end
