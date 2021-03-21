### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ e261d486-89d5-11eb-315d-15e85534d7c7
begin
	using Pkg; Pkg.activate(".");
	using Yao, YaoPlots
end

# ╔═╡ aa2dfab8-89d7-11eb-02c9-ad28b3b76aaa
begin
	using StatsBase: Histogram, fit
	using Plots: bar, scatter!, gr; gr()
	using BitBasis
end

# ╔═╡ 0d011648-89d6-11eb-090f-8b0a40884af8
md"Crear estados entrelazados en Yao es fácil:"

# ╔═╡ 109207f4-89d6-11eb-2393-6bdecf9c8f9b
product_state(2, 00) |> 
    put(2, 1 => H) |> 
    control(2, 1, 2 => X) |> 
    measure

# ╔═╡ 1651279c-89d6-11eb-399a-1feaf6b787fb
md"Podemos visualizar el vector del estado:"

# ╔═╡ 3ba21286-89d6-11eb-12e2-bd80d8143a22
product_state(2, 00) |> 
    put(2, 1 => H) |> 
    control(2, 1, 2 => X) |> 
    state

# ╔═╡ 28c17486-89d6-11eb-2353-db436dbd9446
md"
Este corresponde, si insistimos en la notación tradicional de Dirac, a

$|\psi\rangle = \frac{1}{\sqrt{2}}\left( |00\rangle + |11\rangle \right)$

aunque es más fácilmente visualizable mediante álgebra lineal y la representación de matrices de las compuertas
"

# ╔═╡ 3eb69a02-89d6-11eb-1595-69a7ad452115
circuit = chain(put(2, 1 => H), control(2, 1, 2 => X))

# ╔═╡ 4ddb53ea-89d6-11eb-1e1e-738c8d5ae088
mat(circuit)  # <- Matriz que representa el efecto del circuito

# ╔═╡ 538d07b6-89d6-11eb-332c-7515cd1c95bf
state(product_state(2, 00)) # <- Vector que representa el estado

# ╔═╡ 6b895298-89d6-11eb-3dca-97382a28eb92
md"
Esto además provee una natural geometrización de los conceptos en términos de la geometría de nuestro espacio vectorial complejo y las operaciones unitarias que hagamos sobre él, sin necesidad de forzar conceptos como el de la esfera de Bloch, cuya geometría de todas maneras surje en términos de álgebra lineal.

Exploremos la construcción anterior paso a paso. Comenzamos creando un registro:
"

# ╔═╡ 7014bd02-89d6-11eb-0737-eb316e7e2437
product_state(2, 00) 

# ╔═╡ d41d2276-89d6-11eb-1247-93f396229b78
product_state(2, 01) |> state

# ╔═╡ 419c7374-89d7-11eb-39a9-a1aa2e9302a2
circuit |> plot

# ╔═╡ 6258213a-89d7-11eb-3982-6f7ef3b85276
md"Tras aplicar el circuito, el estado cambia:"

# ╔═╡ 6b8f9a26-89d7-11eb-1543-9dc629b73077
product_state(2, 00) |> circuit |> state

# ╔═╡ 714743f6-89d7-11eb-39d9-2d695effbf37
md"Podemos ver la evolución del estado paso a paso, primero aplicando la transformada de Hadamard:"

# ╔═╡ 80c0a890-89d7-11eb-2155-39f873243698
product_state(2, 00) |> put(2, 1 => H) |> state

# ╔═╡ 7d69e08a-89d7-11eb-1cd0-c541503a50cc
md"Y luego la compuerta NOT controlada:"

# ╔═╡ 84331024-89d7-11eb-293c-8957b0adcd4f
product_state(2, 00) |> put(2, 1 => H) |> control(2, 1, 2 => X) |> state

# ╔═╡ 8e1cdc8e-89d7-11eb-3139-738b19c69665
md"Podemos medir el estado resultante para obtener una respuesta clásica, la cual va a cambiar cada vez que se mide, acorde a su distribución discreta de probabilidad:"

# ╔═╡ 95ea4b22-89d7-11eb-3129-d52297ef9cd7
product_state(2, 00) |> put(2, 1 => H) |> control(2, 1, 2 => X) |> measure

# ╔═╡ 97ca1146-89d7-11eb-1dcd-c929176d9614
md"Esto es más evidente si medimos varias veces en un ensamble de experimentos idénticos:"

# ╔═╡ a05f5496-89d7-11eb-1b98-ff837fd5974d
product_state(2, 00) |> 
    put(2, 1 => H) |> 
    control(2, 1, 2 => X) |> 
    r -> measure(r; nshots=10)

# ╔═╡ aa3b8c94-89d7-11eb-24d9-c34511bd133d
md"Podemos visualizar su distribución de probabilidad utilizando algunos paquetes auxiliares de estadística y de gráficos:"

# ╔═╡ bc8977a8-89d7-11eb-39af-390a1a8c100e
md"Definimos nuestra función para graficar:"

# ╔═╡ c0ebcee0-89d7-11eb-2604-153a3abce266
function plotmeasure(x::Array{BitStr{n,Int},1}) where n
    hist = fit(Histogram, Int.(x), 0:2^n)
    x = 0
    bar(hist.edges[1] .- 0.5, hist.weights, legend=:none, ylims=(collect(0:maximum(hist.weights))), xlims=(collect(0:2^n)), grid=:false, ticks=false, border=:none, color=:lightblue, lc=:lightblue)
    scatter!(0:2^n-1, ones(2^n,1), markersize=0,
     series_annotations="|" .* string.(hist.edges[1]; base=2, pad=n) .* "⟩")
    scatter!(0:2^n-1, zeros(2^n,1) .+ maximum(hist.weights), markersize=0,
     series_annotations=string.(hist.weights))
end

# ╔═╡ c5269314-89d7-11eb-2b1e-63b932d7e0a3
md"Y graficamos:"

# ╔═╡ cb724394-89d7-11eb-0915-cba43d4eac36
product_state(2, 00) |> 
    put(2, 1 => H) |> 
    control(2, 1, 2 => X) |> 
    (x -> measure(x; nshots=100000)) |>
    plotmeasure

# ╔═╡ Cell order:
# ╠═e261d486-89d5-11eb-315d-15e85534d7c7
# ╟─0d011648-89d6-11eb-090f-8b0a40884af8
# ╠═109207f4-89d6-11eb-2393-6bdecf9c8f9b
# ╟─1651279c-89d6-11eb-399a-1feaf6b787fb
# ╠═3ba21286-89d6-11eb-12e2-bd80d8143a22
# ╟─28c17486-89d6-11eb-2353-db436dbd9446
# ╠═3eb69a02-89d6-11eb-1595-69a7ad452115
# ╠═4ddb53ea-89d6-11eb-1e1e-738c8d5ae088
# ╠═538d07b6-89d6-11eb-332c-7515cd1c95bf
# ╟─6b895298-89d6-11eb-3dca-97382a28eb92
# ╠═7014bd02-89d6-11eb-0737-eb316e7e2437
# ╠═d41d2276-89d6-11eb-1247-93f396229b78
# ╠═419c7374-89d7-11eb-39a9-a1aa2e9302a2
# ╟─6258213a-89d7-11eb-3982-6f7ef3b85276
# ╠═6b8f9a26-89d7-11eb-1543-9dc629b73077
# ╟─714743f6-89d7-11eb-39d9-2d695effbf37
# ╠═80c0a890-89d7-11eb-2155-39f873243698
# ╟─7d69e08a-89d7-11eb-1cd0-c541503a50cc
# ╠═84331024-89d7-11eb-293c-8957b0adcd4f
# ╟─8e1cdc8e-89d7-11eb-3139-738b19c69665
# ╠═95ea4b22-89d7-11eb-3129-d52297ef9cd7
# ╟─97ca1146-89d7-11eb-1dcd-c929176d9614
# ╠═a05f5496-89d7-11eb-1b98-ff837fd5974d
# ╟─aa3b8c94-89d7-11eb-24d9-c34511bd133d
# ╠═aa2dfab8-89d7-11eb-02c9-ad28b3b76aaa
# ╟─bc8977a8-89d7-11eb-39af-390a1a8c100e
# ╠═c0ebcee0-89d7-11eb-2604-153a3abce266
# ╟─c5269314-89d7-11eb-2b1e-63b932d7e0a3
# ╠═cb724394-89d7-11eb-0915-cba43d4eac36
