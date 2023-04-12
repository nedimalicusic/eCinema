using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class AccessController : BaseController
    {
        private readonly IAccessManager _accessManager;

        public AccessController(IAccessManager accessManager,ILogger<AccessController> logger) : base(logger)
        {
            _accessManager = accessManager;
        }

        [HttpPost("SignIn")]
        public async Task<IActionResult> SignIn([FromBody] AccessSignInModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var response = await _accessManager.SignInAsync(model, cancellationToken);
                return Ok(response);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing in user");
                return BadRequest(e.Message);
            }
        }

        [HttpPost("SignUp")]
        public async Task<IActionResult> SignUp([FromForm] AccessSignUpModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                await _accessManager.SignUpAsync(model, cancellationToken);
                return Ok();
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing up user");
                return BadRequest(e.Message);
            }
        }
    }
}
