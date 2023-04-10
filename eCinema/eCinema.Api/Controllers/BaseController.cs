using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public abstract class BaseController : ControllerBase
    {
        protected readonly ILogger<BaseController> Logger;

        public BaseController(ILogger<BaseController> logger)
        {
            Logger = logger;
        }
    }
}
