using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EnvironmentController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public EnvironmentController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public ActionResult GetConfigurationMessage()
        {
            return Ok(new { Local = Environment.MachineName, Message = _configuration.GetValue<string>("DatabaseSettings:ConnectionString") });
        }
    }
}