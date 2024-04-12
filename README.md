# Ventrata Challenge


# Authentication Flow

1. **Authentication Flow:**
   - Implement a simple authentication flow with a login page (no registration page needed).
   - Authenticate via a free API - e.g., [DummyJSON](https://dummyjson.com/docs/auth) (or other if you prefer) - and store the auth token for later.
   - Upon successful authentication, navigate the user to a home page where you show the user data with a logout button.
   - On a home page refresh the user data every 10 seconds by calling [DummyJSON](https://dummyjson.com/auth/me). (Refresh it only when the profile is visible!)
   - If the auth token expires during any API request simply navigate to the login page. (no need to handle redirect after login)
   - Automatically log in if the app is started while an auth token is available and not expired.
   - Restrict navigation to all pages when there’s no auth token. Simply navigate to the login page.

2. **Dynamic Products View:**
   - Add bottom navigation to the home page - containing “Profile” and “Products” options. (This part is the “Products” option. Move the user details to the “Profile” option.)
   - Request products from [DummyJSON](https://dummyjson.com/docs/products) every 30 seconds, but each time generate a random skip value for the request (total=100, limit=10, randomize only skip = <0;90>). Refresh only when the products are visible!
   - Add 2 additional fields to the product scheme besides the ones in the API response:
     i. refreshed - number of times this product was downloaded. int type (default to 1).
     ii. amount - number of times this product will be bought. int type (default to 0)
   - When you get new data add them to the ones you already have stored. If it’s a product you didn’t have before, simply add it. If it’s a product that you already had, increment its refreshed value by +1 and then override the old one.
   - Show products (also the refreshed and amount fields) in a table and automatically update it based on the stored data. Don’t use StatefulWidget’s setState() for this!
   - When you tap on any product show its details in a dialog with “+”, ”-” buttons that modify its amount value, “Save” button that updates the product, and “Remove” button that sets amount=0. (both “Save” and “Remove” buttons close the dialog)

3. **Nested Navigator (BONUS):**
   - Use imperative navigation (= older pre-Router navigation) in this new section only!
   - Add a 3rd option - “Sale” - to the bottom navigation on the home page.
   - First page here is a shopping cart page where you show a list of all products that have amount>0 (just a simple “2x Product name” for each is fine) or just “Empty” if no product is selected and a “Checkout” button at the bottom.
     i. When you tap on any product use the same dialog as in Requirement#2, but don’t forget you use the imperative navigation in this section.
     ii. When you press the “Checkout” button navigate to a payment page.
   - On the payment page show a “Pay” button in the center and “back” button in the top left.
     i. When you press the “Pay” button navigate to a success page.
   - On the success simply show “Sale successful” and navigate back to the shopping cart page after 5 seconds. Don’t show the back button here.
     i. Set amount=0 on all products as well, so when you get back the cart is empty.
