use proc_macro::TokenStream;
use quote::quote;
use syn::spanned::Spanned;
use syn::{ItemFn, parse_macro_input};

#[proc_macro_attribute]
pub fn tokio_runtime(_attr: TokenStream, item: TokenStream) -> TokenStream {
    // 1. Parseamos la función sobre la que se colocó el atributo
    let mut input_fn = parse_macro_input!(item as ItemFn);

    // 2. Validación: Nos aseguramos de que realmente sea una función `async`
    if input_fn.sig.asyncness.is_none() {
        return syn::Error::new(
            input_fn.sig.span(),
            "El atributo #[tokio_runtime] solo puede aplicarse a funciones 'async'",
        )
        .to_compile_error()
        .into();
    }

    // 3. Extraemos el cuerpo original de la función
    let original_block = &input_fn.block;

    // 4. Reescribimos el cuerpo de la función inyectando tu `runtime::enter`
    //    Usamos `async move` para capturar los argumentos (como `self`) dentro del nuevo bloque
    input_fn.block = syn::parse_quote!({
        crate::runtime::enter(async move #original_block).await
    });

    // 5. Devolvemos la función modificada al compilador
    TokenStream::from(quote!(#input_fn))
}
