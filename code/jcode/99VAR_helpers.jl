## Impulse Response VAR with external instruments
using Random
using LinearAlgebra
using Statistics

#region functions

function irf_ext(y, Z, p, H)
    (T,K) = size(y)
    (T_z, K_z) = size(Z)
    Y = y[p+1:T,:]'
    X = ones(1,T-p)

    @inbounds for j=1:p
        W = y[p+1-j:T-j,:]'
        X = [X; W]
    end
    ZZ = Z[p+1:end,:]
    # onez = ones(ZZ)
    # ZZZ = [onez ZZ]
    B = (Y*X')/(X*X')
    U = Y-B*X
    Σ = (U*U')/(T_z-K*p-1)
    ## Z might have fewer observations
    ## Thus we have to keep this into considerations
    ##
    ΣηZ = U[:,T-T_z+1:end]*ZZ
    Ση₁Z = ΣηZ[1:1,:] # rescaling factor

    H1 = ΣηZ*Ση₁Z'./(Ση₁Z*Ση₁Z') # rescaling
    scale = ΣηZ[1:1,:]

    #H1 = ΣηZ./Ση₁Z

    #Λ = ΣηZ*pinv(ΣηZ'*inv(Σ)*ΣηZ)*ΣηZ'
    #H1ϵt = Λ*inv(Σ)*U[:, T-T_z+1:end]

    A0inv = [H1 zeros(K,K-1)]
    A = [B[:,2:end];[diagm(0=>ones(K*(p-1))) zeros(K*(p-1),K)]]
    J = [diagm(0=>ones(K)) zeros(K,K*(p-1))]

    IRF = GrowableArray(A0inv[:,1])
    #HD = GrowableArray(zeros(K,K))
    for h in 1:H
        C = J*A^h*J'
        push!(IRF, (C*A0inv)[:,1])
    end

    return IRF, A0inv, B, U, scale
end

function boot_wild_all(A::Array,u::Array,y::Array,ZZ::Array,p::Int64,H::Int64,nrep::Int64,α::Array)
    # Wild Bootstrap
    counter = 1
    (T,K) = size(y)
    (T_z, K_z) = size(ZZ)
    IRFS = GrowableArray(Matrix{Float64}(undef, H+1, K))
    CILv = Array{Float64}(undef, H+1,length(α),K)
    CIHv = similar(CILv)
    lower_bound = Array{Float64}(undef, H+1, length(α))
    upper_bound = similar(lower_bound)
    res = u'
    oneK = ones(1,K)
    oneKz = ones(1,K_z)
    varsb = zeros(T,K)
    Awc = A[:,2:end]
    Ac  = A[:,1]
    rr  = Array{Int16}(undef, T)
    while counter < nrep+1
        rand!(rr, [-1, 1])
        resb = res.*rr[p+1:end]
        #  Deterministic initial values
        for j in 1:K
            for i in 1:p
                @inbounds varsb[i,j] = y[i,j]
            end
        end
        @inbounds for j = p+1:T
            lvars = transpose(varsb[j-1:-1:j-p,:])
            varsb[j,:] = Awc*vec(lvars) + Ac + resb[j-p,:];
        end
        proxies = ZZ.*rr[T-T_z+1:end]
        IRFr, _ = irf_ext(varsb,proxies,p,H)
        push!(IRFS, IRFr)
        counter += 1
    end
    for j in 1:K
        lower = mapslices(u->quantile(u, α./2), IRFS[2:end,:,j], dims=1)'
        upper = mapslices(u->quantile(u, 1.0.-α./2), IRFS[2:end,:,j], dims = 1)'
        CILv[:,:,j] = lower
        CIHv[:,:,j] = upper
    end
    return CILv, CIHv
end

#endregion
