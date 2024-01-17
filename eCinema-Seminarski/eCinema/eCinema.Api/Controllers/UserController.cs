using AutoMapper;
using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Core.Dtos.Photo;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class UserController : BaseCrudController<UserDto, UserUpsertDto, UserSearchObject, IUsersService>
    {
        private readonly IPhotosService _photosService;
        private readonly IMapper _mapper;
        public UserController(IMapper mapper, IUsersService service,IPhotosService photosService, ILogger<UserController> logger) : base(service, logger)
        {
            _mapper = mapper;
            _photosService = photosService;
        }

        [NonAction]
        public override Task<IActionResult> Post(UserUpsertDto upsertDto, CancellationToken cancellationToken = default) => base.Post(upsertDto, cancellationToken);

        [NonAction]
        public override Task<IActionResult> Put(UserUpsertDto upsertDto, CancellationToken cancellationToken = default) => base.Put(upsertDto, cancellationToken);

        [HttpPost]
        public async Task<IActionResult> Post([FromForm] UserUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var upsertDto = _mapper.Map<UserUpsertDto>(model);

                if (model.ProfilePhoto != null && model.ProfilePhoto.Length > 0)
                {
                    var formFile = model.ProfilePhoto;
                    using (var memoryStream = new MemoryStream())
                    {
                        await formFile.CopyToAsync(memoryStream);
                        var photoData = memoryStream.ToArray();

                        var photoInputModel = new PhotoUpsertModel
                        {
                            FileName = formFile.FileName,
                            Type = formFile.ContentType,
                            Content = formFile.OpenReadStream()
                        };

                        var guidId = await _photosService.ProcessAsync(new List<PhotoUpsertModel> { photoInputModel });

                        var photoId = await _photosService.GetPhotoIdByGuidId(guidId[0], cancellationToken);

                        upsertDto.ProfilePhotoId = photoId;
                    }
                }

                var user = await Service.AddAsync(upsertDto, cancellationToken);

                return Ok(user);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to add a user");
                return BadRequest();
            }
        }

        [HttpPut]
        public async Task<IActionResult> Put([FromForm] UserUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var upsertDto = _mapper.Map<UserUpsertDto>(model);

                if (model.ProfilePhoto != null && model.ProfilePhoto.Length > 0)
                {
                    var formFile = model.ProfilePhoto;
                    using (var memoryStream = new MemoryStream())
                    {
                        await formFile.CopyToAsync(memoryStream);
                        var photoData = memoryStream.ToArray();

                        var photoInputModel = new PhotoUpsertModel
                        {
                            FileName = formFile.FileName,
                            Type = formFile.ContentType,
                            Content = formFile.OpenReadStream()
                        };

                        var guidId = await _photosService.ProcessAsync(new List<PhotoUpsertModel> { photoInputModel });

                        var photoId = await _photosService.GetPhotoIdByGuidId(guidId[0], cancellationToken);

                        upsertDto.ProfilePhotoId = photoId;
                    }
                }
                else
                {

                    var user = await Service.GetByIdAsync(model.Id, cancellationToken);

                    upsertDto.ProfilePhotoId = (int)user!.ProfilePhotoId;
                }

                await Service.UpdateAsync(upsertDto, cancellationToken);

                return Ok(upsertDto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get top users");
                return BadRequest();
            }
        }

        [HttpPut("ChangePassword")]
        public async Task<IActionResult> ChangepPassword([FromBody] UserChangePasswordDto dto, CancellationToken cancellationtoken = default)
        {
            try
            {
                await Service.ChangePassword(dto, cancellationtoken);
                return Ok();
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to change password!");
                return BadRequest();
            }
        }

    }
}
