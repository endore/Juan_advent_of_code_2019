using DelimitedFiles
using DataFrames
function partOne(input_arr = readdlm("day6\\input.txt", ',', String))
    # part one
    input_df = clean_input(input_arr)

    #: initiate total orbits with all unique objects in input_arr
    total_orbits_dict = initiate_total_orbits_dict(input_df)

    COM_leafs = get_leafs(input_df,"COM")

    if length(COM_leafs) == 0
        throw(DomainError(parent_to_leafs,"No COM parent entry found"))
    end

    #: update total_orbits_dict starting from parent = "COM" and using the parent_to_leafs
    update_orbits!(total_orbits_dict,input_df)

    return sum(values(total_orbits_dict))
end

function partTwo(input_arr = readdlm("day6\\input.txt", ',', String))
    # part two
    input_df = clean_input(input_arr)

    #: initiate total orbits with all unique objects in input_arr
    total_orbits_dict = initiate_total_orbits_dict(input_df)

    COM_leafs = get_leafs(input_df,"COM")

    if length(COM_leafs) == 0
        throw(DomainError(parent_to_leafs,"No COM parent entry found"))
    end

    #: update total_orbits_dict starting from parent = "COM" and using the parent_to_leafs
    update_orbits!(total_orbits_dict,input_df)

    min_transfers = min_orbit_transfers(total_orbits_dict,input_df)

    return min_transfers
end

function clean_input(input)
    output = split.(input,")")
    df = DataFrame(Parent = String[], Child = String[])
    for i in output
        push!(df,(i[1],i[2]))
    end
    return df
end

function initiate_total_orbits_dict(input_clean)
    dict = Dict{String,Int}()
    for i in union(input_clean.Parent,input_clean.Child)
        dict[i] = 0
    end
    return dict
end

function update_orbits!(total_orbits_dict,clean_input, parent = "COM")
    children = get_leafs(clean_input,parent)
    for child in children
        total_orbits_dict[child] = total_orbits_dict[parent] + 1
        update_orbits!(total_orbits_dict,clean_input,child)
    end
end

function get_leafs(input_df,parent)
    return input_df.Child[input_df.Parent .== parent,:]
end

function get_orbit_chain(input_df,child,list = [])
    parent = input_df.Parent[input_df.Child .== child,:][1]
    push!(list,parent)
    if parent != "COM"
        get_orbit_chain(input_df,parent,list)
    else
        # reverse the order once we reach COM
        list = list[end:-1:1]
    end
    return list
end

function get_first_common_root(chain1,chain2)
    chain1_rev = chain1[end:-1:1]
    chain2_rev = chain2[end:-1:1]
    Max = length(chain1_rev)
    if Max < length(chain2_rev)
        Max = length(chain2_rev)
    end
    fcr = "COM"
    for i in 2:Max
        if chain1_rev[i] == chain2_rev[i]
            fcr = chain1_rev[i]
        else
            break
        end
    end
    return fcr
end

function min_orbit_transfers(total_orbits,clean_input,YOU = "YOU", SAN = "SAN")
    you_chain = get_orbit_chain(clean_input,YOU)
    san_chain = get_orbit_chain(clean_input,SAN)
    first_common_root = get_first_common_root(you_chain,san_chain)

    min_transfers = total_orbits[YOU] + total_orbits[SAN] -2(total_orbits[first_common_root]+1)

    return min_transfers
end
