using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

using eCinema.Core;

namespace eCinema.Api.Utilities
{
    public class AuthorizationAttribute : TypeFilterAttribute
    {
        public AuthorizationAttribute(params Role[] roles) : base(typeof(AuthorizationFilter))
        {
            Arguments = new object[] { roles };
        }

        public class AuthorizationFilter : IAuthorizationFilter
        {
            private readonly Role[] _roles;

            public AuthorizationFilter(Role[] roles)
            {
                _roles = roles;
            }

            public void OnAuthorization(AuthorizationFilterContext context)
            {
                try
                {
                    var user = context.HttpContext.User;
                    var roleClaim = user.Claims.FirstOrDefault(c => c.Type == ClaimNames.Role);
                    if (roleClaim == null)
                        throw new Exception();

                    if (!Enum.TryParse<Role>(roleClaim.Value, out var role) || !_roles.Contains(role))
                        throw new Exception();
                }
                catch
                {
                    context.Result = new UnauthorizedResult();
                }
            }
        }
    }
}
